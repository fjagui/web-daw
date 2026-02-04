# Administración de Servidores de Aplicaciones

## 1. Arquitectura y configuración básica del servidor de aplicaciones.

El **servidor de aplicaciones** es un componente software responsable de **ejecutar la lógica de negocio** de aplicaciones web. Actúa como un **entorno de ejecución (runtime)** que ofrece servicios de infraestructura para que el código del desarrollador funcione correctamente.

### 1.1. El Modelo de Tres Capas y Roles

La implantación de aplicaciones web suele seguir un modelo donde el servidor de aplicaciones se sitúa en el centro:

1. **Capa de Presentación:** Navegador y servidor web.
2. **Capa de Negocio:** El servidor de aplicaciones ejecutando código (servlets, beans, APIs).
3. **Capa de Datos:** El sistema gestor de bases de datos (SGBD).

**Diferencia de roles:**

* **Servidor Web (p. ej., Apache, Nginx):** Optimizado para manejar miles de peticiones HTTP simultáneas, gestionar certificados SSL y despachar archivos rápidos.
* **Servidor de Aplicaciones (p. ej., Tomcat, GlassFish, WildFly, Kestrel):** Capaz de interpretar lenguajes (Java, C#, Python, PHP), gestionar conexiones a bases de datos, manejar sesiones complejas y garantizar la integridad de las transacciones.

### 1.2. Componentes y Funcionamiento

Un servidor de aplicaciones actúa como *middleware* y proporciona servicios como la gestión del ciclo de vida, pool de conexiones y seguridad centralizada.  
Sus componentes internos trabajando coordinadamente son:

1. **Conectores (Connectors):** Puntos de escucha (ej. HTTP/1.1 en puerto 8080 o AJP para comunicarse con servidores web frontales).
2. **Contenedor de Aplicaciones (Container):** Corazón del servidor que instancia clases, inyecta dependencias y gestiona los objetos `request` y `response`.
3. **Gestor de Despliegue (Deployer):** Módulo encargado de recibir paquetes (.war, .ear o carpetas), descomprimirlos y mapear las URLs.

---

#### 📚 Recursos de interés

* **[IBM - Guía de arquitectura de tres capas](https://www.ibm.com/es-es/topics/three-tier-architecture){:target="_blank"}**: Explicación detallada de IBM sobre la división de responsabilidades entre la capa de presentación, negocio (App Server) y datos.  

* **[IBM - Servidor Web. Servidos de Aplicaciones.](https://www.ibm.com/es-es/think/topics/web-server-application-server){:target="_blank"}**: Diferencias entre servidores web y servidores de aplicaciones.

---
## 2. Componentes y configuración del ecosistema de aplicaciones.

La administración de un servidor de aplicaciones se organiza en **capas de visibilidad**, permitiendo definir reglas globales para todo el servidor o ajustes específicos para una aplicación concreta. 

A continuación, se detallan los componentes y archivos clave de los ecosistemas más relevantes:

### 2.1. [Ecosistema Java (Apache Tomcat).](https://tomcat.apache.org/tomcat-10.1-doc/config/index.html){target=blank}

Tomcat utiliza una estructura de directorios estandarizada que facilita el aislamiento entre el motor y las aplicaciones:

* **`bin/`**: Contiene los scripts de control del ciclo de vida (`startup.sh`, `shutdown.sh`) y el núcleo de ejecución (`catalina.sh`).
* **`conf/`**: Es el centro neurálgico del servidor. Incluye:
    * `server.xml`: Configura conectores (puertos 8080, 8009) y la arquitectura del servidor.
    * `web.xml`: Parámetros de configuración global para todas las aplicaciones (filtros, tipos MIME).
    * `tomcat-users.xml`: Gestión de la autenticación para las herramientas de administración.

* **`lib/`**: Directorio de **bibliotecas compartidas**. Aquí se ubican archivos `.jar` (como drivers JDBC) que deben ser visibles para todas las aplicaciones desplegadas.
* **`webapps/`**: Zona de despliegue donde se ubican los archivos **.WAR** o carpetas de aplicación.

### 2.2 [Ecosistema PHP. (PHP-FPM).](https://www.php.net/manual/es/install.fpm.php){target=blank}

A diferencia de los módulos antiguos, PHP-FPM funciona como un servicio independiente que gestiona procesos mediante **Pools**.

* **Gestión por Pools**: Permite segmentar recursos. Por ejemplo, un pool para la web principal y otro con límites más restrictivos para tareas de administración.
* **Configuración en capas**:  
  
    * **Motor (`php.ini`)**: Define límites técnicos globales como `memory_limit` o `upload_max_filesize`. Se suele ubicar en `/etc/php/8.x/fpm/php.ini`.
    * **Administrador (`php-fpm.conf`)**: Gestiona el comportamiento del servicio en el sistema operativo (archivos de log, PID).
    * **Pool (`www.conf`)**: Define el punto de conexión (Socket Unix o Puerto TCP) y la gestión de procesos (`max_children`). Se encuentran en `/etc/php/8.x/fpm/pool.d/`.

### 2.3. Ecosistema Python (WSGI/ASGI)

En Python, el servidor de aplicaciones es un componente que "envuelve" a la aplicación para que esta sea portable entre diferentes servidores web.

* **Protocolos de interfaz**:
    * [**WSGI**](https://es.wikipedia.org/wiki/WSGI){target=blank}: Estándar síncrono para frameworks como Django o Flask.
    * [**ASGI**](https://en.wikipedia.org/wiki/Asynchronous_Server_Gateway_Interface){target=blank}: Estándar moderno asíncrono, necesario para manejar WebSockets y alta concurrencia.


* **Servidores comunes**: 
    * [**Gunicorn**](https://gunicorn.org/){target=blank}: Robusto para WSGI.
    * [**Uvicorn**](https://uvicorn.dev/){target=blank}: Ultrarrápido para ASGI.
* **Entornos Virtuales (`venv`)**: Pieza fundamental para el **aislamiento de bibliotecas**, permitiendo que cada aplicación tenga su propia versión de dependencias sin conflictos.

### 2.4. Ecosistema JavaScript (Node.js/PM2).
A diferencia de otros servidores, Node.js utiliza un modelo de E/S sin bloqueo y un **entorno de ejecución monohilo**. Para entornos de producción, esto genera dos retos: la aplicación puede detenerse ante un error no controlado y, por defecto, solo aprovecha un núcleo de la CPU. Para solventarlo, se utiliza [**PM2**](https://pm2.keymetrics.io/docs/usage/quick-start/){target=blank}, el gestor de procesos estándar de la industria.

**Funciones críticas de PM2:**  

* **Alta Disponibilidad (Auto-restart):** Monitoriza la aplicación en tiempo real y la reinicia instantáneamente si el proceso falla o el servidor se reinicia.
* **Modo Clúster (Escalabilidad Horizontal):** Permite ejecutar múltiples instancias de la misma aplicación, balanceando la carga entre todos los núcleos de la CPU sin necesidad de modificar el código.
* **Gestión de Logs:** Centraliza y automatiza la rotación de los archivos de salida (`stdout`) y errores (`stderr`), facilitando la auditoría del sistema.

---

## 3. Autenticación de usuarios y dominios de seguridad.

La seguridad en los servidores de aplicaciones se gestiona de forma desacoplada del código fuente, lo que permite al administrador de sistemas modificar las políticas de acceso sin necesidad de recompilar o alterar la aplicación.

### 3.1. Seguridad Declarativa

Es un modelo donde las restricciones de seguridad se definen en los archivos de configuración del servidor (como el `web.xml` en Java o archivos de configuración de middleware).

Una de las ventajas clave de este modelo es permitir una **gestión centralizada**. El administrador define qué roles (ej. `admin`, `user`) tienen permiso para acceder a determinadas rutas, delegando en el servidor la responsabilidad de interceptar y validar cada petición antes de que llegue a la aplicación.

### 3.2. Dominios de Seguridad (Realms)

Un **Dominio de Seguridad** o *Realm* es un "almacén" de usuarios y roles que el servidor de aplicaciones consulta para autenticar a los clientes. La potencia de este sistema radica en que el servidor puede conectarse a diferentes fuentes de datos de forma transparente para la aplicación:

* **Ficheros planos:** Ideales para entornos de desarrollo (ej. `tomcat-users.xml`).
* **Bases de Datos (JDBC):** Los usuarios y contraseñas se gestionan en tablas SQL.
* **Directorios Activos (LDAP/AD):** Integración con la infraestructura de identidad corporativa de la empresa.

### 3.3. Componentes de Protección: Filtros y Controladores

Para garantizar la integridad de los recursos y las APIs REST, el servidor utiliza componentes especializados que actúan como barreras:

* **Filtros de Seguridad (Interceptores):** Son componentes que analizan la petición HTTP antes de que sea procesada. Verifican la presencia de tokens (como JWT), cookies de sesión o certificados digitales.
* **Controladores de Acceso:** Una vez identificado el usuario, el contenedor de aplicaciones comprueba si los roles asignados en el *Realm* coinciden con los permisos requeridos para el recurso solicitado, denegando el acceso con errores 401 (No autorizado) o 403 (Prohibido) si es necesario.

---

#### 📚 Recursos de interés

* **[Oracle - Conceptos de Seguridad en Java EE](https://docs.oracle.com/javaee/7/tutorial/security-intro.htm)**{target=blank}: Una guía técnica fundamental para entender la diferencia entre seguridad declarativa y programática.
* **[Apache Tomcat - Configuración de Realms](https://tomcat.apache.org/tomcat-10.1-doc/realm-howto.html){target=blank}**: Documentación oficial sobre cómo conectar Tomcat con diferentes almacenes de usuarios (JDBC, LDAP, etc.).

---

## 4. Administración de sesiones.

El protocolo HTTP es, por diseño, un protocolo **sin estado** (*stateless*); cada petición es independiente de la anterior. El servidor de aplicaciones es el encargado de crear la ilusión de una "conversación" continua entre el cliente y el servidor.

### 4.1. Gestión de estado y mecanismos de identificación

Para recordar al usuario, el servidor utiliza mecanismos de rastreo que permiten vincular una petición entrante con los datos almacenados en memoria:

* **Identificadores de Sesión (Session ID):** Tras el primer acceso, el servidor genera un identificador único (ej. `JSESSIONID` en Java, `PHPSESSID` en PHP).
* **Mecanismos de transporte:** Este ID se suele enviar al cliente mediante una **Cookie** de sesión. Si el cliente tiene las cookies desactivadas, el servidor puede recurrir a la **reescritura de URLs** (añadiendo el ID como parámetro en cada enlace).
* **Contexto de Sesión:** El servidor reserva un espacio en memoria para almacenar objetos de usuario (carritos de compra, perfiles, tokens), evitando consultar la base de datos en cada clic.

### 4.2. Persistencia y ciclo de vida.

La administración de sesiones requiere un equilibrio entre la usabilidad y el rendimiento del servidor:

* **Persistencia de sesiones:** Los servidores profesionales pueden configurarse para persistir las sesiones en disco o en una base de datos externa (como Redis). Esto permite que, si el servidor se reinicia, los usuarios no pierdan su sesión activa.
* **Tiempos de expiración (Timeouts):** Es una directiva de seguridad y rendimiento vital.
    * **Seguridad:** Minimiza el riesgo de secuestro de sesión (*[Session Hijacking](https://developer.mozilla.org/en-US/docs/Glossary/Session_Hijacking){target=blank}*).
    * **Recursos:** Libera la memoria RAM ocupada por sesiones inactivas. Un timeout mal configurado puede provocar errores de "Memoria insuficiente" (*Out of Memory*) en el servidor de aplicaciones si hay miles de usuarios que no cerraron sesión explícitamente.
---

#### 📚 Recursos de interés

* **[Mozilla Developer Network (MDN) - Cookies y gestión de sesiones](https://developer.mozilla.org/es/docs/Web/HTTP/Cookies){target=blank}**: Una guía fundamental para entender cómo el navegador y el servidor cooperan mediante el uso de cookies.
* **[Apache Tomcat - The Manager Component](https://tomcat.apache.org/tomcat-10.1-doc/config/manager.html){target=blank}**: Documentación técnica sobre cómo Tomcat gestiona la creación, persistencia y caducidad de las sesiones en memoria.
---

## 5. Integración con servidores web.

En entornos de producción, no se suele exponer el servidor de aplicaciones directamente a Internet. En su lugar, se utiliza un servidor web frontal que actúa como intermediario, delegando solo la ejecución dinámica al *backend*.

### 5.1. Métodos de integración (Los "Puentes")

La comunicación entre ambos servidores se realiza mediante diferentes protocolos según las necesidades de rendimiento y la ubicación de los servicios:

* **Proxy Inverso (HTTP):** Es el estándar universal. El servidor web (Nginx/Apache) recibe la petición y la reenvía al servidor de aplicaciones (Node.js, Python, Java) como si fuera un cliente más. Es fácil de configurar y depurar.
* **Protocolos Binarios (FastCGI / AJP):** Son protocolos optimizados específicamente para la comunicación entre servidores.
    * **FastCGI:** Utilizado por PHP-FPM para transmitir datos binarios de forma mucho más eficiente que el texto plano de HTTP.
    * **AJP (Apache JServ Protocol):** Protocolo específico de Tomcat que permite mantener conexiones abiertas y transmitir metadatos de la petición original de forma persistente.


* **Sockets de Unix:** Si ambos servidores residen en la misma máquina física, se puede evitar la pila de red TCP/IP utilizando un archivo especial en el sistema de archivos. Es el método que ofrece la menor latencia posible.

#### Resumen de casos.

| Protocolo | Aplicación / Runtime común | Ejemplo de dirección o socket | Escenario típico |
| --- | --- | --- | --- |
| **HTTP (Proxy)** | **Node.js** (Express), **Python** (Gunicorn/Django) | `http://127.0.0.1:3000` | Apps modernas y contenedores Docker. |
| **FastCGI** | **PHP-FPM** (WordPress, Laravel) | `127.0.0.1:9000` | Servidor web y PHP en distintos contenedores o máquinas. |
| **AJP** | **Apache Tomcat** (Java Enterprise) | `127.0.0.1:8009` | Entornos Java corporativos con Apache frontal. |
| **Unix Sockets** | **PHP-FPM** o **Gunicorn** | `/run/php/php8.2-fpm.sock` | Máximo rendimiento cuando Web y App están en la misma VM. |


### 5.2. Ventajas del despliegue con Frontal Web

La cooperación entre servidores no es solo una cuestión de conectividad, sino de eficiencia y seguridad:

1. **Seguridad y Aislamiento:** El servidor de aplicaciones se mantiene en una red privada, ocultando su versión y topología. El servidor web actúa como "escudo" frente a ataques comunes.
2. **Gestión de Contenido Estático:** Los servidores web son extremadamente rápidos sirviendo imágenes, CSS y JS. Dejar que ellos manejen estos archivos libera al servidor de aplicaciones para que se concentre exclusivamente en la lógica de negocio.
3. **Terminación SSL/TLS:** El servidor web centraliza la gestión de certificados. El cifrado y descifrado de datos se realiza en la entrada, descargando de esta computación costosa al *backend*.
4. **Balanceo de Carga:** Un único frontal web puede repartir el tráfico entre varias instancias del servidor de aplicaciones, permitiendo la escalabilidad horizontal y la alta disponibilidad.


### ↗️ [Actividad externa.](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-22-04){target=blank}

---

#### 📚 Recursos de interés

* **[Nginx - Entendiendo el Proxy Inverso y el Balanceo de Carga](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)**: Guía oficial de Nginx sobre cómo configurar el paso de peticiones a servidores de aplicaciones.
* **[Apache - Módulo mod_proxy_ajp](https://httpd.apache.org/docs/2.4/mod/mod_proxy_ajp.html)**: Documentación técnica sobre el protocolo AJP para conectar Apache con Tomcat de forma eficiente.

---


## 6. Despliegue de aplicaciones en el servidor de aplicaciones.

El despliegue (*deployment*) es el proceso de instalar, configurar y activar una aplicación en el servidor. Un administrador debe dominar tanto los formatos de empaquetado como la jerarquía de carga de las bibliotecas para evitar conflictos entre aplicaciones.

### 6.1. Formatos, bibliotecas y jerarquía.

Cada ecosistema tiene su propia forma de empaquetar el software y gestionar sus dependencias:

* **Ecosistema Java (Archivos .WAR):** Las aplicaciones se empaquetan en archivos *Web Application Archive* (.WAR). Al colocarlos en la carpeta `webapps/`, el servidor los despliega automáticamente.
* **Aislamiento y Bibliotecas Compartidas:** Es crítico entender la prioridad de carga para evitar el error "Jar Hell", que ocurre cuando el cargador de clases encuentra múltiples versiones de la misma biblioteca o clases duplicadas en el classpath, causando conflictos de dependencia:
    * **Bibliotecas Privadas (`/WEB-INF/lib`):** Son exclusivas de la aplicación. Se cargan primero (**Local-First**).
    * **Bibliotecas Compartidas (`/lib` del servidor):** Son comunes para todas las aplicaciones (ej. drivers de base de datos). Se cargan solo si no existen en la carpeta privada.


* **Ecosistema Python (Requirements y venv):** El despliegue se basa en el archivo `requirements.txt`. El administrador debe asegurar el uso de un **entorno virtual (venv)** para que las librerías de una aplicación no sobrescriban las de otra en el sistema global.

### 6.2. Ajustes Técnicos de Despliegue
Una vez desplegado el código, el administrador de sistemas debe realizar una serie de ajustes de optimización para garantizar que la aplicación sea estable, segura y eficiente bajo carga real.

* **Gestión de Memoria (JVM / PHP-FPM / Node.js)**: Consiste en asignar el tamaño adecuado del montón de memoria (Heap Size) que el proceso tiene permitido consumir. Si el administrador infravalora este recurso, el servidor sufrirá errores críticos de OutOfMemory (OOM) y caídas constantes del servicio al intentar procesar volúmenes altos de datos.

* **Configuración de Timeouts:** Es vital establecer límites de tiempo para la ejecución de hilos y procesos. Un timeout mal configurado permite que peticiones pesadas o con errores queden "colgadas" indefinidamente, generando procesos "zombie" que agotan los ciclos de la CPU y saturan la capacidad de respuesta del servidor.

* **Optimización del Pool de Conexiones:** En lugar de abrir y cerrar una conexión a la base de datos por cada petición, el administrador configura un grupo (pool) de conexiones pre-abiertas que se reutilizan. Sin este ajuste, el Servidor de Gestión de Bases de Datos (SGBD) puede saturarse rápidamente debido al coste computacional de abrir miles de conexiones simultáneas.

* **Inyección de Variables de Entorno:** Es la práctica de externalizar la configuración sensible (como DB_PASSWORD o API_KEY) y las rutas de sistema fuera del código fuente. Esto no solo facilita despliegues en diferentes entornos (Desarrollo, Preproducción, Producción) sin modificar archivos, sino que evita fallos graves de seguridad al no exponer claves en el repositorio de código.

## 7. Seguridad del servidor de aplicaciones.

La seguridad no es un producto, sino un proceso basado en el principio de **Defensa en Profundidad**. El objetivo es reducir la superficie de ataque para que, en caso de vulnerabilidad en la aplicación, el impacto en el sistema operativo es nulo o mínimo.

### 7.1. Aislamiento de procesos y privilegios

El primer escudo de defensa es el control de la identidad que ejecuta el servicio:

* **Ejecución No-Root:** Bajo ninguna circunstancia el servidor de aplicaciones debe ejecutarse con el usuario `root`. Se deben emplear usuarios de sistema dedicados (como `tomcat`, `www-data` o `node`) configurados **sin shell de acceso** (`/usr/sbin/nologin`) para evitar que un atacante tome el control de la consola.
* **Aislamiento del Sistema de Archivos:** Se debe aplicar el principio de "mínimo privilegio":
    * El código de la aplicación debe pertenecer a un usuario distinto al que ejecuta el servidor y tener permisos de **solo lectura**.
    * El servidor solo debe tener permisos de **escritura** en directorios específicos y controlados, como carpetas de logs o de subida de archivos (*uploads*).

### 7.2. Hardening (bastionado) y configuración de red.

El bastionado consiste en "limpiar" el servidor de funciones innecesarias que podrían ser explotadas:

* **Ocultación de huella (fingerprinting):** Un servidor nunca debe revelar su versión ni la tecnología que usa en las cabeceras HTTP (ej. desactivar `Server Tokens` en Apache o `expose_php` en PHP). Esto dificulta al atacante la búsqueda de exploits específicos.
* **Desactivación de funciones peligrosas:** En ecosistemas como PHP, el administrador debe usar la directiva `disable_functions` para bloquear comandos que permitan ejecutar código en el sistema operativo (como `exec()`, `shell_exec()` o `system()`).
* **Gestión de secretos:** Las credenciales de bases de datos o claves de API jamás deben estar en el código. El administrador debe inyectarlas mediante **archivos de entorno (.env)** protegidos con permisos `600` (lectura solo para el dueño).
* **Segmentación de red (firewall):** El servidor de aplicaciones debe ser "invisible" desde el exterior. Mediante `iptables` o `ufw`, se deben bloquear los puertos de escucha (3000, 8080, 9000) para el tráfico externo, permitiendo conexiones únicamente desde la dirección IP local del Servidor Web (Proxy).

---

#### 📚 Recursos de interés

* **[OWASP - Guía de Seguridad en Servidores de Aplicaciones](https://cheatsheetseries.owasp.org/cheatsheets/DotNet_Security_Cheat_Sheet.html)**: Referencia mundial sobre los estándares de seguridad que deben aplicarse en el despliegue de software.
* **[DigitalOcean - Cómo asegurar tu infraestructura de red](https://www.digitalocean.com/community/tutorials/7-security-measures-to-protect-your-servers)**: Una guía excelente sobre firewalls, SSH y gestión de usuarios para administradores.

--- 

## 8. Documentación y pruebas.

En un entorno profesional, "lo que no está documentado, no existe" y "lo que no se ha probado, no funciona".

La fase final de la administración consiste en validar que el sistema soporta la carga prevista y en asegurar que cualquier otro técnico pueda entender y mantener la infraestructura creada.

### 8.1. Pruebas de funcionamiento y estrés

No basta con que la aplicación "cargue". El administrador debe validar el comportamiento del servidor bajo condiciones de uso real y extremo:

* **Pruebas Funcionales de Infraestructura:** Verificar que los mecanismos de sesión persisten (ej. tras un reinicio del servicio), que el Proxy Inverso reenvía correctamente las cabeceras y que los errores (404, 500) están personalizados para no revelar información del sistema.
* **Pruebas de Carga y Rendimiento (Benchmarking):** Se utilizan herramientas de generación de tráfico para medir la estabilidad y los tiempos de respuesta:
    * **`ab` (Apache Benchmark):** Ideal para pruebas rápidas de concurrencia.
    * **`Siege`:** Útil para simular múltiples usuarios navegando por diferentes URLs simultáneamente.
    * **`wrk`:** Herramienta moderna de alto rendimiento para medir la latencia y el *throughput* (peticiones por segundo).


* **Métricas clave:** El administrador debe vigilar el **Tiempo de Respuesta (Latencia)** y el **Tasa de Errores** cuando el servidor alcanza el límite de su *pool* de procesos o memoria.

### 8.2. Documentación Técnica de la Infraestructura

La documentación debe ser un "manual de vuelo" para otros administradores. Debe evitar la narrativa excesiva y centrarse en datos operativos:

* **Contenido esencial:**
    * **Esquema de Red:** Diagrama de flujo desde el cliente hasta la base de datos (puertos, protocolos e IPs).
    * **Matriz de Configuración:** Listado de archivos modificados (ej. `/etc/php/.../www.conf`) y su propósito.
    * **Manual de Despliegue:** Comandos exactos para actualizar la aplicación y reiniciar los servicios.
    * **Registro de Usuarios y Roles:** Definición de quién tiene acceso a la administración del servidor.

* **Formatos Estándar:** Se recomienda el uso de **Markdown** por su capacidad de ser versionado en **Git**. Esto permite que la documentación evolucione junto con la infraestructura, manteniendo un historial de cambios técnico y legible.

---

#### 📚 Recursos de interés.

* **[DigitalOcean - Cómo usar Apache Benchmark (ab) para probar el rendimiento](https://www.digitalocean.com/community/tutorials/how-to-use-apachebench-to-do-load-testing-on-an-ubuntu-13-10-vps){target=blank}**: Una guía práctica para empezar a medir la capacidad de tus servidores.
* **[LoadView - Guía de pruebas de estrés vs. pruebas de carga](https://www.loadview-testing.com/es/pruebas-de-carga-vs-pruebas-de-estres/){target=blank}**: Articulo conceptual para entender qué estamos buscando al lanzar miles de peticiones.
* **[Write the Docs - Guía de documentación técnica](https://www.writethedocs.org/guide/writing/beginners-guide-to-docs/){target=blank}**: Principios de la industria para escribir documentación que realmente sea útil para otros ingenieros de sistemas.

## 9. Virtualización, contenedores y nube

La administración moderna ha evolucionado desde la instalación manual en servidores físicos hacia modelos de abstracción que permiten desplegar aplicaciones en segundos, garantizando que el entorno de desarrollo sea idéntico al de producción.

### 9.1. Contenedores (Docker) y microservicios.

El uso de contenedores ha revolucionado el despliegue al permitir empaquetar la aplicación junto con todo su entorno (runtime, bibliotecas y configuración) en una unidad ligera y aislada.

* **Portabilidad y Reproducibilidad:** Un contenedor de Node.js o Java funcionará exactamente igual en el portátil del desarrollador que en un servidor en la nube, eliminando el problema de "en mi máquina sí funciona".
* **Eficiencia de Recursos:** A diferencia de la virtualización tradicional (VMs), los contenedores comparten el núcleo del sistema operativo host, lo que permite ejecutar decenas de servicios en el mismo hardware con un consumo mínimo de RAM.
* **Infraestructura como Código (IaC):** Mediante archivos como el `Dockerfile` o `docker-compose.yml`, el administrador define la infraestructura mediante texto, permitiendo versionar el servidor igual que se hace con el código fuente.

### 9.2. Evolución hacia el Cloud (PaaS y Serverless)

La gestión de servidores de aplicaciones en la nube permite delegar gran parte de la carga administrativa al proveedor (AWS, Azure, Google Cloud):

* **PaaS (Platform as a Service):** El administrador ya no gestiona el sistema operativo ni el parcheado del servidor. Solo despliega el artefacto (.war, .py, .js) y el proveedor se encarga de la escalabilidad y la disponibilidad (ej. AWS Elastic Beanstalk o Heroku).
* **Serverless (Arquitectura sin servidor):** Representa el nivel máximo de abstracción. La aplicación se divide en funciones que solo se ejecutan cuando reciben una petición. El administrador gestiona eventos y límites, olvidándose por completo de procesos, hilos o servidores encendidos 24/7.
* **Escalabilidad Elástica:** Capacidad de aumentar o disminuir el número de instancias del servidor de aplicaciones de forma automática según la demanda de tráfico real, optimizando así los costes operativos.

---

#### 📚 Recursos de interés.

* **[Docker - Documentación oficial para principiantes](https://docs.docker.com/get-started/overview/){target=blank}**: La mejor introducción conceptual sobre qué son los contenedores y por qué son necesarios hoy en día.
* **[AWS - ¿Qué es la computación sin servidor (Serverless)?](https://aws.amazon.com/es/serverless/){target=blank}**: Explicación detallada del modelo de ejecución bajo demanda y sus beneficios en la administración.
* **[IBM - Comparativa: IaaS vs. PaaS vs. SaaS](https://www.ibm.com/es-es/topics/iaas-paas-saas){target=blank}**: Guía esencial para que el alumno comprenda hasta dónde llega su responsabilidad en cada modelo de nube.
