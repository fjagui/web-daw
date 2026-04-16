# Servicios de Red en el Despliegue Web

## 1. Sistemas de Nombres Jerárquicos (DNS)

Imagina que quieres llamar a un amigo. No te aprendes su número de teléfono de 9 cifras, buscas su **nombre** en la agenda. El **DNS (Domain Name System)** es, en esencia, la agenda telefónica de Internet. Traduce nombres fáciles de recordar (como `www.google.com`) en direcciones IP que las máquinas entienden (`142.250.200.68`).  

El **Sistema de Nombres de Dominio (DNS)** se define técnicamente como una **base de datos jerárquica y distribuida**, cuyo propósito principal es la resolución de nombres en redes basadas en el protocolo IP.

A diferencia de una base de datos centralizada, el DNS no reside en un único equipo; su información está repartida entre miles de servidores a nivel global, lo que garantiza **escalabilidad, redundancia y autonomía administrativa**.

  * **Jerárquica:** Porque organiza los nombres en niveles (Raíz, TLD, Dominio, Subdominio), permitiendo que cada nivel delegue la autoridad al siguiente.
  * **Distribuida:** Porque cada zona de la red es gestionada por un servidor de nombres específico (servidor autoritativo), evitando que un fallo en un punto colapse todo el sistema.
  * **Protocolo:** Utiliza el puerto **53** y opera principalmente sobre **UDP** para consultas rápidas, aunque recurre a **TCP** para transferencias de zona o respuestas que superan los 512 bytes.

**💡 Ejemplo. "La Delegación de Tareas"**  

Si el DNS fuera una empresa, el *Director General (Raíz*) no sabría dónde está el archivo de un cliente. Si le preguntas, él te diría: *"No lo sé, pero pregunta al Jefe de Departamento de Ventas (.com)"*. El Jefe de Ventas te diría: *"Pregunta al Encargado de la oficina de Madrid (https://www.google.com/search?q=google.com)"*. Finalmente, el Encargado te daría el documento exacto.

**Nadie tiene toda la información, pero todos saben a quién preguntar.**

### 1.1. Estructura y nomenclatura: El espacio de nombres (FQDN)

El sistema de nombres no es caótico; es una **jerarquía invertida** que parece un árbol. Se lee de derecha a izquierda y cada parte se separa por un punto.

* **La Raíz (Root):** Es el nivel superior, representado por un punto invisible al final de cada dominio (ej. `google.com.`).
* **TLD (Top Level Domain):** Son las extensiones finales como `.com`, `.org`, `.es` o `.edu`.
* **Dominio de Segundo Nivel:** Es el nombre que compramos (ej. `iesgrancapitan`).
* **Subdominio:** Divisiones dentro del dominio para organizar servicios (ej. `aula.`, `correo.`, `www.`).

Cuando unimos todas estas partes, obtenemos un **FQDN (Fully Qualified Domain Name)**, como `servidor1.proyectos.iesgrancapitan.org.`.

### 1.2. Funcionamiento de la resolución de nombres.
Para entender el DNS no basta con saber que "traduce nombres"; hay que comprender el recorrido que realiza una consulta a través de una serie de preguntas y respuestas encadenadas que ocurren en milisegundos. En este engranaje participan dos piezas clave: **[el DNS Resolver](https://www.ionos.es/digitalguide/servidores/know-how/dns-resolver/){target=blank}** (utilizado por aplicaciones como el navegador) y el **Servidor DNS Recursivo**, generalmente asignado por tu proveedor de internet, a menos que realices una configuración manual de la red para utilizar servidores públicos como los de Google (8.8.8.8) o Cloudflare (1.1.1.1).

Cuando escribes una URL, se inicia una *carrera de relevos* llamada **resolución de nombres** que sigue este orden:

1.  **Caché Local (El atajo):** Antes de salir a Internet, tu ordenador (Stub Resolver) mira en su propio archivo `hosts` y en su memoria caché. Si visitaste esa web hace poco, la respuesta es instantánea.
2.  **Servidor Recursivo (El investigador):** Si la IP no está en caché, tu PC envía una **consulta recursiva** al servidor de tu ISP (Movistar, Orange, etc.). Este servidor tiene la misión de encontrar la IP "cueste lo que cueste" haciendo el trabajo necesario.
3.  **Consultas Iterativas (El camino jerárquico):** El servidor recursivo pregunta a la jerarquía global mediante consultas iterativas ("Si no lo sabes tú, dime quién sabe"):
    * **Servidores Raíz (Root):** El recursivo pregunta: "¿Dónde está .es?". El Raíz responde: "No lo sé, pero pregunta a los servidores de nombres de .es".
    * **Servidores TLD (.es):** El recursivo pregunta: "¿Dónde está ejemplo.es?". El TLD responde: "No lo sé, pero pregunta en estos servidores autoritativos".
    * **Servidor Autoritativo:** Es el servidor final que tiene la dirección IP. Él responde: "La IP de www.ejemplo.es es 1.2.3.4".

**Conceptos técnicos fundamentales**

Para dominar este proceso, se debe distinguir claramente entre los tipos de consulta y la gestión de la memoria:

* **Consulta Recursiva:** Es la que el cliente (tu PC) hace al servidor DNS. El cliente exige una respuesta completa (la IP o un error) y espera a que el servidor devuelva la solución.
* **Consulta Iterativa:** Es la que el servidor DNS hace a otros servidores. El servidor preguntado puede dar una respuesta parcial o remitir a otro servidor que tenga más autoridad sobre el dominio.
* **La importancia del TTL (Time To Live):** Es un valor numérico en segundos que indica cuánto tiempo debe el resolutor guardar una respuesta en su caché antes de volver a preguntar al servidor autoritativo.
    * **TTL Alto (ej. 24h):** Menos tráfico y carga más rápida, pero los cambios de IP tardan mucho en propagarse.
    * **TTL Bajo (ej. 5min):** Cambios casi instantáneos, pero aumenta la carga del servidor y la resolución es ligeramente más lenta.

### 1.3. Tipos de registros DNS esenciales para el despliegue

Como administradores de aplicaciones web, no solo configuramos IPs. Existen diferentes "fichas" (registros) en la base de datos DNS:

| Registro | Nombre | Función | Ejemplo |
| :--- | :--- | :--- | :--- |
| **A** | Address | Apunta un nombre a una dirección **IPv4**. | `web.es` -> `1.2.3.4` |
| **AAAA** | IPv6 Address | Apunta un nombre a una dirección **IPv6**. | `web.es` -> `2001:db8::1` |
| **CNAME** | Canonical Name | Un alias de otro nombre. Útil para subdominios. | `www` -> `web.es` |
| **MX** | Mail Exchange | Indica qué servidor gestiona el correo del dominio. | `mail.web.es` |
| **TXT** | Text | Información de texto (muy usado para verificar propiedad de la web). | `v=spf1 ...` |


!!! note "🛠️ Práctica Guiada: Investigando el DNS desde la terminal"
    No necesitamos instalar nada para ver cómo funciona el DNS. Vamos a usar la herramienta [`dig`](https://docs.oracle.com/es-ww/iaas/Content/DNS/Tasks/testingdnsusingdig.htm){target=blank} (en Linux/Mac) o `nslookup` (en Windows).

    1.  **Consulta básica:** Averigua la IP de un dominio:
        `dig google.com` o `nslookup google.com`
    2.  **Rastreo completo (Trace):** Mira cómo tu consulta salta de servidor en servidor hasta llegar al autoritativo:
        `dig +trace marca.com`
    3.  **Consultar un registro específico:** ¿Quién gestiona el correo de Gmail?
        `dig gmail.com MX`
    4.  **El archivo secreto:** Abre el archivo `hosts` de tu sistema (en Linux `/etc/hosts`, en Windows `C:\Windows\System32\drivers\etc\hosts`). 
        * Añade una línea: `127.0.0.1  facebook.com`
        * Intenta entrar en Facebook desde el navegador. ¡Acabas de hacer un "secuestro" local de DNS! (No olvides borrarlo después).



#### 📚 Recursos de interés
* **[DNS Checker](https://dnschecker.org/){target=blank}**: Herramienta online para ver cómo se está propagando un cambio de DNS por todo el mundo.
* **[Cloudflare: ¿Qué es el DNS?](https://www.cloudflare.com/es-es/learning/dns/what-is-dns/){target=blank}**: Una de las mejores guías visuales y divulgativas sobre el tema.


## 2. Configuración de DNS para aplicaciones web

Configurar el DNS para una web no es un proceso de "un solo clic". Requiere identificar qué registros necesitamos y cómo ajustarlos para que la experiencia del usuario sea rápida y sin errores.

### 2.1. Identificación de necesidades según el entorno

No configuramos igual una web de pruebas que una tienda online en producción. Debemos definir:

  * **El Dominio Principal (Root Domain):** Por ejemplo, `miempresa.com`.
  * **Subdominios de Servicio:** Es habitual separar funciones: `www` para la web, `api` para los datos, `cdn` para imágenes pesadas.
  * **Entornos de Staging:** Antes de lanzar la web oficial, solemos usar subdominios como `test.miempresa.com` o `dev.miempresa.com`.

### 2.2. Registros Críticos en el Despliegue

Para que nuestra aplicación sea accesible, trabajaremos principalmente con estos tres tipos de registros en la zona DNS:

1.  **Registro A (Host):** Es el más básico. Asocia el nombre de tu web a la **IP pública fija** de tu servidor.
      * *Ejemplo:* `tienda.es` -\> `80.10.20.30`
2.  **Registro CNAME (Alias):** Muy útil para redirigir subdominios al nombre principal. Si mañana cambias la IP del servidor, solo tienes que actualizar el registro A, y todos los CNAME que apunten a él se actualizarán solos.
      * *Ejemplo:* `www.tienda.es` -\> `tienda.es`
3.  **Registro MX (Mail Exchange):** Si tu aplicación web envía correos (confirmaciones de compra, registros), necesitas que este registro apunte al servidor de correo correcto para que no sean bloqueados por SPAM.

### 2.3. Parámetros de configuración afectados

Al editar estos registros, hay dos valores técnicos que deciden si el despliegue es un éxito o un desastre:

  * **El valor TTL (Time To Live):** Como vimos, es el tiempo que los servidores del resto del mundo guardan tu IP en su memoria.
      * **Estrategia de despliegue:** 24 horas antes de cambiar tu web a un servidor nuevo, **baja el TTL a 300 segundos**. Así, cuando hagas el cambio real, la propagación será casi instantánea.
  * **FQDN (Fully Qualified Domain Name):** Es el nombre completo incluyendo el punto final (ej. `www.ejemplo.es.`). En muchos archivos de configuración de servidores DNS, si olvidas el punto final, el sistema intentará añadir el dominio otra vez (ej. `www.ejemplo.es.ejemplo.es`), provocando un error de acceso.


!!! note "🛠️ Actividad propuesta: Nuevo despliegue"
    Imagina que eres el técnico que ha configurado   una nueva web en un servidor con IP `145.1.2.3`. No tienes acceso al panel DNS del cliente. Escribe el mensaje formal que enviarías al administrador de red solicitando los cambios necesarios.
    ```
    Debes incluir:
    1. Registro A para el dominio principal.
    2. Registro CNAME para el subdominio `www`.
    3. Sugerencia de TTL para el día del lanzamiento.
    ```


#### 📚 Recursos de interés

  * **[Google Cloud DNS: Mejores prácticas](https://cloud.google.com/dns/docs/best-practices%3Fhl%3Des){target=blank}**: Guía avanzada sobre cómo organizar zonas y TTLs.
  * **[Mxtoolbox](https://mxtoolbox.com/){target=blank}**: La navaja suiza para verificar si tus registros MX y A están bien configurados tras un despliegue.

## 3. Servicio de directorios. 

Un servicio de directorio es una "guía telefónica" avanzada para redes de computadoras. No solo guarda nombres e IPs, sino que almacena información detallada sobre todo lo que compone una organización: quién es el jefe de quién, qué impresora puede usar cada empleado o qué contraseña tiene el administrador.

### 3.1. ¿Qué es un Servicio de Directorio?

Es una base de datos especializada, optimizada para la **lectura y la búsqueda**, que organiza **Eso es la magia de LDAP.**la información de forma jerárquica (en forma de árbol invertido).

* **Diferencia con una BD Relacional:** Mientras que una base de datos normal (como MySQL) es excelente para transacciones constantes (ventas, cambios de stock), un Directorio está diseñado para responder miles de veces a la pregunta: *"¿Tiene este usuario permiso para entrar aquí?"*.
* **Ejemplos comerciales:** El más famoso es **Active Directory** (de Microsoft), pero en entornos de software libre el estándar es **OpenLDAP**.



### 3.2. El Protocolo LDAP (Lightweight Directory Access Protocol)

LDAP no es el directorio en sí, sino el **idioma (protocolo)** que usamos para hablar con él. Es el estándar que permite que una aplicación web (por ejemplo, un Moodle o un WordPress) se conecte al servidor de la empresa para que los empleados entren con su misma clave de siempre.

#### Conceptos Clave de la estructura LDAP:
Para entenderse con LDAP, hay que conocer su "vocabulario":

1.  **Entrada (Entry):** Es la unidad básica (como una "fila" en Excel). Puede ser un usuario, un grupo o una impresora.
2.  **Atributos:** Son las propiedades de la entrada (nombre, email, teléfono, contraseña).
3.  **DN (Distinguished Name):** Es la "ruta completa" y única de una entrada. Es como la dirección postal absoluta.
    * *Ejemplo:* `cn=Juan Perez, ou=Ventas, dc=miempresa, dc=com`
4.  **OU (Organizational Unit):** Son las "carpetas" o contenedores que usamos para organizar (ej: Departamento de IT, Recursos Humanos).



### 3.3. LDAP en el despliegue de aplicaciones.

Como administradores de aplicaciones web, configuraremos LDAP para lograr la **Autenticación Centralizada (Single Sign-On)**.

* **Escenario sin LDAP:** Si la empresa tiene 10 aplicaciones web, el usuario tendría 10 usuarios y 10 contraseñas diferentes. Un caos para el usuario y para el administrador si alguien se va de la empresa.
* **Escenario con LDAP:** La aplicación web no guarda contraseñas. Cuando el usuario intenta entrar, la web le pregunta al servidor LDAP: *"¿Es este usuario quien dice ser?"*. Si el LDAP dice "sí", la web le deja pasar.

💡Ejemplo.  
Imaginemos nuestro Centro como un directorio LDAP.

  - `dc=instituto, dc=local` (La raíz/base)  
  - `ou=profesores` y `ou=alumnos` (Las ramas principales)  
  - Dentro de `ou=alumnos`, tenemos `cn=alumno1`, `cn=alumno2`...  
   
Si el profesor cambia la contraseña de un alumno en el servidor central, ese alumno ya puede entrar con la nueva clave en el ordenador del aula, en el WiFi y en la plataforma de notas.


## 4. Configuración y Personalización del Directorio

Una vez instalado un servidor LDAP (como **OpenLDAP**), el administrador debe saber cómo "darle forma" al árbol y cómo introducir los datos. A diferencia de una base de datos SQL donde usamos comandos como `INSERT` o `UPDATE`, en LDAP usamos archivos de configuración y de intercambio de datos.

### 4.1. Archivos básicos de configuración

Existen dos formas históricas de configurar un servidor OpenLDAP:

* **El archivo `slapd.conf` (Método tradicional):** Es un único archivo de texto plano donde se definen los parámetros globales: qué base de datos se usa, dónde se guardan los archivos físicos y qué contraseña tiene el administrador (`rootpw`). Aunque es más fácil de leer para un humano, requiere reiniciar el servidor para aplicar cualquier cambio.
* **La base de datos `cn=config` (Método moderno u OLC):** Es la forma actual de configurar LDAP. La propia configuración del servidor es, en sí misma, un árbol LDAP. Esto permite modificar parámetros del servidor "en caliente" (sin reiniciar), realizando consultas LDAP contra la rama de configuración.



### 4.2. Gestión de entradas: El formato LDIF

Para añadir usuarios, crear grupos o modificar contraseñas, el estándar universal es el **LDIF (LDAP Data Interchange Format)**.

Un archivo LDIF es un archivo de texto simple que describe una entrada o un cambio en el directorio. Es el "lenguaje de comunicación" entre diferentes servidores de directorio.

#### Ejemplo de un archivo LDIF para crear un usuario:
```ldif
dn: uid=jdoe,ou=Users,dc=miempresa,dc=com
objectClass: inetOrgPerson
objectClass: posixAccount
cn: John Doe
sn: Doe
uid: jdoe
userPassword: {SSHA}password_encriptada
homeDirectory: /home/jdoe
uidNumber: 1001
gidNumber: 1001
```



### 4.3. Herramientas de gestión (Comandos de consola)

Es conveniente familiarizarse con los comandos que procesan los archivos LDIF:

1.  **`ldapadd`**: Para insertar nuevas entradas (usuarios, OUs) desde un archivo LDIF.
2.  **`ldapmodify`**: Para cambiar atributos de entradas existentes (por ejemplo, cambiar un número de teléfono).
3.  **`ldapsearch`**: La herramienta más usada. Permite realizar consultas a la base de datos para encontrar información (ej: *"dame el email del usuario jdoe"*).
4.  **`ldappasswd`**: Comando específico para cambiar de forma segura la contraseña de un usuario.

Cuando desplegamos una aplicación web que requiere LDAP, el flujo suele ser:

1.  Diseñamos el árbol en un archivo **LDIF**.
2.  Lo cargamos con **`ldapadd`**.
3.  Configuramos nuestra aplicación web para que use un usuario con permisos de lectura (llamado *Bind DN*) para buscar a los usuarios cuando intenten hacer login.

## 5. Autenticación Centralizada para Aplicaciones Web

En lugar de que cada aplicación web gestione su propia tabla de usuarios y contraseñas (lo cual es un riesgo de seguridad y un caos administrativo), la aplicación se convierte en un **cliente LDAP**.

### 5.1. El proceso de *Bind*: El saludo inicial

En el mundo LDAP, "autenticarse" se denomina técnicamente hacer un **Bind**. Es el proceso mediante el cual un cliente (la aplicación web) se identifica ante el servidor para establecer una sesión.

1.  **Conexión Anónima (opcional):** La aplicación conecta al servidor para buscar si el usuario existe.
2.  **Búsqueda:** Localiza el **DN** del usuario (ej. `uid=pedro,ou=alumnos...`).
3.  **Bind de Usuario:** La aplicación intenta un "Bind" usando ese DN y la contraseña que el usuario escribió en el formulario web.
4.  **Respuesta:** Si el servidor LDAP acepta el Bind, la aplicación sabe que la contraseña es correcta y le permite el acceso.



### 5.2. Niveles de acceso: Autenticación Simple vs. SASL

No todas las conexiones al directorio tienen el mismo nivel de seguridad. Dependiendo de la sensibilidad de los datos, configuraremos uno u otro:

* **Autenticación Simple:** Es el método más común. El usuario y la contraseña se envían en texto plano (o cifrados si usamos **LDAPS** sobre el puerto 636). Es fácil de configurar pero arriesgado si no se usa una capa de cifrado (TLS/SSL).
* **SASL (Simple Authentication and Security Layer):** Es un marco de trabajo más robusto. Permite usar mecanismos externos como **Kerberos** o certificados digitales. En este nivel, la contraseña nunca viaja por la red, lo que lo hace ideal para entornos de máxima seguridad corporativa.

### 5.3. Parámetros de conexión de la aplicación web

Cuando instalas una aplicación web y queremos activar el login por LDAP, necesitajemos configurar tres parámetros críticos:

| Parámetro | Descripción | Ejemplo Típico |
| :--- | :--- | :--- |
| **Base DN** | El punto del árbol donde la web empezará a buscar usuarios. | `ou=Users,dc=instituto,dc=local` |
| **Bind DN** | Un usuario especial (con permisos de lectura) que la web usa para entrar al LDAP y buscar a otros usuarios. | `cn=web_service,dc=instituto,dc=local` |
| **Filtro de búsqueda** | La regla para encontrar al usuario. Define qué campo del LDAP coincide con el "Login" de la web. | `(&(objectClass=person)(uid=%s))` |

El **Bind DN** (usuario de servicio) no debería ser nunca el administrador principal (`cn=admin`). Se recomienda crear un usuario específico con permisos limitados de solo lectura para evitar que, si la web es hackeada, el atacante obtenga el control total del directorio.

Ejemplo de flujo completo:

1. El alumno introduce su nombre en `campus.ies.es`.
2. La web usa el **Bind DN** para entrar al LDAP.
3. Busca en el **Base DN** a alguien que coincida con ese nombre usando el **Filtro**.
4. Una vez encontrado, intenta un **Bind** con la contraseña del alumno.
5. Si el servidor dice "OK", el alumno entra al campus.

## 6. Integración del Directorio en el Despliegue

Cuando desplegamos una aplicación profesional (un CRM, un ERP o un CMS), a menudo nos encontramos con que el estándar de LDAP no es suficiente o que la seguridad por defecto es demasiado débil. 

### 6.1. Adaptación de la configuración: Esquemas a medida

Un **Esquema (Schema)** en LDAP es el conjunto de reglas que define qué tipos de objetos y qué atributos se pueden guardar. Es el "diccionario" del servidor.

Por defecto, LDAP sabe qué es un nombre (`cn`) o un email (`mail`), pero quizás tu aplicación web necesita guardar un dato específico que no existe, como el "Número de Seguridad Social" o el "NIE de un alumno". En este caso debemos importar o crear nuevos archivos de esquema (`.schema` o `.ldif`).  

 * **Esquemas comunes:** `core.schema`, `cosine.schema`, `inetorgperson.schema`.
* **Ampliación:** Si la aplicación lo requiere, el administrador añade el esquema al servidor para que este "entienda" los nuevos campos. Sin esto, el servidor LDAP rechazaría cualquier intento de la aplicación de guardar datos desconocidos.

### 6.2. Seguridad en la consulta: Implementación de LDAPS

Como hemos visto, el protocolo LDAP simple envía la información (¡incluyendo las contraseñas!) en texto claro. En un despliegue serio, esto es inaceptable. Para protegerlo, usamos **LDAPS** o **StartTLS**.

1.  **LDAPS (LDAP over SSL/TLS):**
    * Funciona de forma similar al HTTPS.
    * Utiliza el **puerto 636** por defecto.
    * Toda la conexión está cifrada desde el primer segundo.
2.  **StartTLS:**
    * Utiliza el puerto estándar **389**.
    * La conexión empieza en texto claro, pero inmediatamente el cliente y el servidor "negocian" subir el nivel de seguridad a una conexión cifrada.

Para la implementación el servidor LDAP debe tener:  

* Un **Certificado Digital** (puede ser propio o de una entidad como Let's Encrypt).
* La **Clave Privada** correspondiente.
* El **Certificado de la CA** (Autoridad de Certificación) configurado.


El flujo de integración segura en un despliegue con LDAP será:

1.  **Instalación:** Levantar el servidor LDAP.
2.  **Preparación:** Cargar los **Esquemas** necesarios para la aplicación.
3.  **Cifrado:** Configurar los certificados para habilitar el puerto **636 (LDAPS)**.
4.  **Vinculación:** En la configuración de la aplicación web, cambiar la URL de conexión:
    * *De:* `ldap://servidor.empresa.com:389`
    * *A:* `ldaps://servidor.empresa.com:636`
5.  **Prueba:** Verificar mediante `ldapsearch` con el flag de seguridad que los datos viajan protegidos.


## 7. Despliegue Avanzado: DNS y Directorio en la Nube y Contenedores

El despliegue moderno busca la **escalabilidad** (crecer rápido) y la **disponibilidad** (que nunca falle). Para ello, utilizamos herramientas que automatizan la configuración que hemos visto en los apartados anteriores.

### 7.1. Servidores de red en Docker: Despliegue rápido

Docker permite empaquetar un servidor DNS o LDAP con todas sus dependencias en un "contenedor". Esto elimina el problema de *"en mi ordenador funciona, pero en el servidor no"*.

* **OpenLDAP en Docker:** En lugar de una instalación compleja, usamos imágenes oficiales como `osixia/openldap`.
    * **Variables de Entorno:** Configuramos el `LDAP_DOMAIN` y `LDAP_ADMIN_PASSWORD` directamente en el archivo `docker-compose.yml`.
    * **Persistencia:** Los datos del directorio (la base de datos) se guardan en **volúmenes** para que, si el contenedor se borra, los usuarios no se pierdan.

* **CoreDNS:** Es el servidor DNS moderno escrito en Go, diseñado específicamente para contenedores.
    * Es el DNS por defecto que utiliza **Kubernetes**.
    * **Configuración:** Se gestiona mediante un archivo llamado `Corefile`, que es mucho más sencillo y legible que los antiguos archivos de zona de BIND.

### 7.2. Servicios gestionados en la nube (SaaS / PaaS)

Hoy en día, muchas empresas prefieren no gestionar sus propios servidores LDAP o DNS y contratan **servicios gestionados**. El proveedor de la nube se encarga de los parches de seguridad, los backups y la alta disponibilidad.

#### A. Directorios Activos en la Nube
* **Microsoft Entra ID (antes Azure AD):** Es la evolución del Active Directory para la nube. No usa LDAP puro por defecto (usa protocolos web como OAuth o SAML), pero permite conectar aplicaciones web modernas de forma nativa.
* **AWS Directory Service:** Amazon ofrece un "Microsoft AD gestionado". Tú no ves el servidor, solo tienes una dirección IP para conectar tus aplicaciones mediante los procesos de **Bind** que estudiamos en el apartado 5.

#### B. Cloud DNS (Google Cloud / AWS Route 53)
* En lugar de configurar un archivo de zona en un servidor Linux, usas una consola web o una API.
* **Ventaja clave:** Estos DNS están distribuidos en cientos de centros de datos por todo el mundo (Anycast), lo que garantiza que la resolución de nombres sea ultrarrápida desde cualquier país.



---

### 🛠️ Comparativa: ¿Cuándo usar cada uno?

| Característica | Servidor Propio (On-premise) | Contenedores (Docker) | Servicio en la Nube (Cloud) |
| :--- | :--- | :--- | :--- |
| **Control** | Total (Hardware y Software) | Total sobre el Software | Limitado (solo configuración) |
| **Despliegue** | Lento (horas/días) | Muy rápido (segundos) | Instantáneo |
| **Mantenimiento** | Alto (parches, backups) | Medio (gestión de imágenes) | Bajo (lo hace el proveedor) |
| **Uso ideal** | Redes locales aisladas | Desarrollo y Microservicios | Aplicaciones Globales y Escalables |

## 8. Documentación de Adaptaciones en Servicios de Red

La documentación es el activo más valioso de un departamento de IT. Permite la continuidad del servicio, facilita las auditorías de seguridad y reduce drásticamente el tiempo de resolución de incidencias.

### 8.1. Elaboración de inventarios: El mapa de activos

Un inventario no es solo una lista; es una representación fiel de la infraestructura que hemos configurado en los apartados anteriores.

#### A. Registro de zonas DNS
Debemos documentar cada zona bajo nuestra responsabilidad, detallando:  

* **Nombre de la Zona:** (ej. `empresa.es`).
* **Servidores Autoritativos:** (Primario y secundarios).
* **Tabla de Registros Críticos:** Un resumen de los registros A, CNAME y MX más importantes para el negocio.
* **Política de TTL:** Justificación de por qué se usan tiempos largos (estabilidad) o cortos (flexibilidad).

#### B. Estructura del Árbol LDAP
Dado que el directorio es jerárquico, la documentación debe reflejar ese "árbol":  

* **Base DN:** (La raíz del directorio).
* **Esquema de OUs:** Descripción de para qué sirve cada Unidad Organizativa (Usuarios, Grupos, Equipos).
* **Diccionario de Atributos:** Si hemos realizado adaptaciones (Apartado 6.1), debemos documentar qué atributos personalizados hemos añadido y para qué aplicación sirven.

### 8.2. Manuales de procedimientos: El "Cómo se hizo"

Mientras que el inventario dice *qué tenemos*, el manual de procedimientos explica *cómo operar* con ello. Para un despliegue de aplicaciones web, son esenciales dos tipos de documentos:

1.  **Guía de Despliegue (Provisionamiento):**  
   
    * Pasos exactos para dar de alta un nuevo registro DNS.
    * Procedimiento para crear un nuevo usuario de servicio (Bind DN) en LDAP.
    * Configuración del Proxy Inverso (Nginx/Apache) para apuntar a la nueva app.

2.  **Registro de Cambios (Change Log):**  
   
    * Cada vez que se modifica un registro DNS o se altera un esquema LDAP, debe quedar registrado: **Quién, Cuándo, Qué se cambió y Por qué**.
    * Esto es vital para "volver atrás" (Rollback) si algo falla tras el despliegue.
