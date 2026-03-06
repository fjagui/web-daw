# Servicios de tranferencia de archivos.
## 1. Introducción al protocolo de transferencia de archivos (FTP)

El protocolo **FTP (File Transfer Protocol)** es uno de los pilares más antiguos de Internet, diseñado específicamente para el intercambio de archivos entre un cliente y un servidor, independientemente del sistema operativo que utilicen.

### 1.1. Fundamentos y funcionamiento: El modelo Cliente-Servidor

A diferencia de la navegación web (HTTP), donde normalmente solo descargamos datos, el FTP está optimizado para flujos bidireccionales de gran volumen. El servidor permanece a la escucha de peticiones, mientras que el cliente inicia la sesión para subir (*upload*) o bajar (*download*) archivos.

**Conceptos clave:**

* **Estado de la conexión:** A diferencia de HTTP, que es *stateless*, FTP es un protocolo **con estado**. El servidor mantiene abierta la sesión del usuario y "recuerda" en qué directorio se encuentra mientras dure la conexión.
* **Modos de transferencia:**
    * **ASCII:** Para archivos de texto plano (ajusta los saltos de línea según el SO).
    * **Binario:** Para imágenes, ejecutables o archivos comprimidos (copia bit a bit).



### 1.2. Canales de comunicación: Control y Datos

Esta es la característica más distintiva y problemática de FTP: **utiliza dos conexiones paralelas** para completar una sola tarea.

1. **Canal de Control (Puerto 21):**
      * Se utiliza para enviar comandos (ej. `USER`, `PASS`, `LIST`, `RETR`).
      * Es el canal donde se produce la autenticación.
      * Permanece abierto durante toda la sesión.

2. **Canal de Datos (Puerto variable):**
      * Se abre únicamente cuando se va a transferir un archivo o un listado de directorios.
      * Se cierra automáticamente al terminar la transferencia.
      * El puerto utilizado depende del **modo de conexión** (Activo o Pasivo), que veremos en el siguiente apartado.

!!! note "🛠️ Práctica Guiada: Hablando FTP por consola"
    Para entender que el canal de control es puro texto plano, vamos a simular un cliente sin usar software específico, usando simplemente `telnet` o `nc` (netcat).  

    1. **Abre una terminal** y conéctate a un servidor FTP público (ej. el de Debian):  
       `telnet test.rebex.net 21`
    2. El servidor responderá con un código `220`. **Identifícate**:  
       `USER anonymous`
    3. El servidor pedirá password (código `331`). **Envía cualquier correo**:  
       `PASS invitado@correo.com`
    4. Si recibes un `230 Login successful`, ¡estás dentro!
    5. Prueba el comando `SYST` para saber qué SO usa el servidor y `QUIT` para salir.
   
#### 📚 Recursos de interés

* **[RFC 959 - File Transfer Protocol](https://datatracker.ietf.org/doc/html/rfc959){target=blank}**: El documento oficial que define el estándar desde 1985. 
* **[FTP en Wikipedia](https://es.wikipedia.org/wiki/Protocolo_de_transferencia_de_archivos){target=blank}**: Información completa sobre el protocolo.

## 2. Modos de conexión y NAT

Como vimos en el apartado anterior, el FTP separa el control de los datos. El gran reto para un administrador es configurar cómo se establece esa segunda conexión (la de datos), especialmente cuando hay **firewalls** o **NAT** (Network Address Translation) de por medio.

### 2.1. Modo Activo (PORT)

Quién abre la conexión de datos: el servidor.  

¿Cómo funciona?

1. El cliente conecta al puerto 21 del servidor y se autentica.
2. Cuando el cliente quiere descargar o subir archivos, le dice al servidor:  
   `PORT h1,h2,h3,h4,p1,p2`  
   Esto indica su IP y puerto donde puede recibir la conexión de datos.  
   `Puerto = p1*256 + p2`

3. El servidor abre la conexión desde su puerto 20 al puerto que el cliente indicó.
   
**El problema:** Si el cliente está detrás de un firewall o un router doméstico (NAT), éste bloqueará la conexión entrante del servidor porque no ha sido solicitada desde dentro hacia fuera.

### 2.2. Modo Pasivo (PASV)

Es el modo estándar hoy en día y el más amigable para los clientes. Aquí, el **servidor** es quien indica en qué puerto escuchará los datos.

1. El cliente se conecta al puerto 21 del servidor y se autentica.
2. Cuando el cliente quiere hacer una transferencia envía el comando `PASV`.
3. El servidor responde con una IP y un puerto dinámico donde escuchará la conexión de datos.  
    `227 Entering Passive Mode (192,168,1,10,195,80)`  
    Los primeros cuatro númesos son la IP del servidor y los dos últimos se utilizan para calcular el puerto:
    `Puerto = 195 * 256 + 80`  
    `Puerto = 49920 + 80` 
    `Puerto = 50000` 
    El cliente se conecta al puerto 50000 para enviar o recibir datos.

4. **El cliente inicia la conexión** de datos al puerto indicado.

**Ventaja:** Como todas las conexiones las inicia el cliente (hacia fuera), los firewalls del cliente no suelen dar problemas. El administrador del servidor solo debe preocuparse de abrir ese rango de puertos en su propio firewall.

!!! note "🛠️ Práctica Guiada: Observando la negociación de puertos"
    Vamos a utilizar un cliente FTP gráfico (como **FileZilla**) para identificar qué modo estamos usando y qué puertos se están negociando.  

    1. **Configuración inicial**: Abre FileZilla y ve a *Edición -> Opciones -> FTP*. Observa que "Pasivo" suele estar marcado por defecto.  
    2. **Conexión**: Conéctate a un servidor (puedes usar uno local si ya tienes instalado `vsftpd` o uno público).  
    3. **Análisis del Log**: Observa el log de comandos. Asegúrate de configurar adecuadamente el nivel de información en los mensajes de log.  
        - Busca la línea que dice: `Comando: PASV`
        - Verás una respuesta del servidor parecida a: `227 Entering Passive Mode (192,168,1,10,156,78)`  
        - **Cálculo del puerto**: Los dos últimos números (156 y 78) indican el puerto mediante la fórmula:
          
            Puerto = (156 x 256) + 78 = 40014

    4. **Prueba**: Intenta cambiar la configuración a "Modo Activo" en FileZilla y observa si la conexión de listado de directorios falla (común en redes con NAT o firewalls restrictivos).


#### 📚 Recursos de interés

* **[Slacksite - FTP Modes Explained](http://slacksite.com/other/ftp.html){target=blank}**: Una de las mejores explicaciones visuales y técnicas sobre la diferencia entre ambos modos.

## 3. Instalación y configuración de servidores de archivos

La administración de un servidor FTP implica no solo que el servicio "funcione", sino que esté limitado para no comprometer los recursos del sistema.

### 3.1. Ecosistemas comunes: Selección de software

Existen diversas opciones dependiendo del sistema operativo y las necesidades:

* **vsftpd (Linux):** Enfocado en la seguridad y el rendimiento. Es el más usado en servidores de producción.
* **ProFTPD (Linux):** Muy potente y con una configuración similar a la de Apache (basada en directivas).
* **FileZilla Server (Windows):** Interfaz gráfica intuitiva, ideal para administradores que no dominan la terminal.

### 3.2. Configuración del servicio: vsftpd.conf

En Linux, casi toda la configuración reside en `/etc/vsftpd.conf`. Los parámetros básicos que todo administrador debe conocer son:

| Directiva            | Descripción                                                           | Valor recomendado    |
| ------------------   | --------------------------------------------------------------------- | --------------------   |
|`listen=YES`          | Permite que el servidor funcione de forma independiente (standalone). | `YES`                |
|`anonymous_enable`    | Permite o deniega el acceso sin contraseña.                           | `NO` (por seguridad) |
|`local_enable`        | Permite el acceso a los usuarios locales del sistema (`/etc/passwd`). | `YES`                |
|`write_enable`        | Habilita los comandos de escritura (subir archivos, borrar).          | `YES`                |

### 3.3. Configuración del Modo Pasivo (Firewall-friendly)
Como vimos en el apartado anterior, para que el FTP funcione tras un firewall, debemos definir un rango de puertos para los datos:

```bash
pasv_min_port=40000
pasv_max_port=40010
pasv_address=IP_PUBLICA_DEL_SERVIDOR
```

---
!!! note "🛠️ Práctica Guiada: Instalación y primer *Hardening*"

    Vamos a instalar el servidor y aplicar una configuración básica de seguridad.  
    1. **Instalación:**  
    `sudo apt update && sudo apt install vsftpd`  
    2. **Copia de seguridad del config original:**  
    `sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak`  
    3. **Edición de parámetros:** Abre el archivo con `sudo nano /etc/vsftpd.conf` y asegúrate de que las siguientes líneas estén así (descoméntalas si es necesario):

    ```text
    local_enable=YES
    write_enable=YES
    chroot_local_user=YES
    allow_writeable_chroot=YES
    ```
    4. **Reiniciar el servicio:**  
    `sudo systemctl restart vsftpd`  
    5. **Estado del servicio:** Verifica que está corriendo con:  
    `sudo systemctl status vsftpd`.
---

### 3.4. Gestión de Permisos y Cuotas

Un servidor de aplicaciones suele tener poco espacio en disco. Es vital controlar cuánto puede subir cada usuario:

* **Permisos de sistema (Linux):** El usuario de FTP debe tener permisos de lectura/escritura en la carpeta de destino (ej. `/var/www/html`).
* **Cuotas de disco:** Mediante la herramienta `quota` de Linux, podemos limitar que un usuario no llene el disco duro, bloqueando su capacidad de subida si sobrepasa los X GB asignados.

!!! example "🎯 Actividades externas."
    Completa el tutorial adaptado a tu distrubición Linux.

    <div class="grid cards" markdown>

    -   :material-file-certificate: __Actividad : DigitalOcean__
        ---
        Configurar vsftpd en Ubuntu.
        
        [:octicons-arrow-right-24: Acceso al tutorial](https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-on-ubuntu-12-04){target=blank}

    </div>


#### 📚 Recursos de interés.

* **[Man page de vsftpd.conf](https://security.appspot.com/vsftpd/vsftpd_conf.html){target=blank}**: Documentación completa de todas las directivas posibles.

## 4. Gestión de Usuarios y Seguridad de Acceso

La administración de identidades en un servidor FTP determina quién puede entrar y, lo más importante, qué parte del servidor puede ver.

### 4.1. Tipos de usuarios

Existen tres perfiles principales de acceso que debemos gestionar:

1. **Usuarios Locales:** Son cuentas reales del sistema operativo (definidas en `/etc/passwd`). Tienen su propio directorio *home* y, por defecto, podrían tener acceso a la terminal (SSH).
2. **Usuarios Virtuales:** No existen en el sistema operativo. Sus credenciales se guardan en una base de datos externa o un archivo. Son más seguros porque, si la cuenta se ve comprometida, el atacante no tiene un usuario real del sistema.
3. **Usuarios Anónimos:** Acceden con el nombre `anonymous` y sin contraseña (o usando un email). Se usan para repositorios públicos de descarga. Por seguridad, hoy en día se desaconsejan en entornos de producción.

### 4.2. Enjaulamiento (Chroot)

El **chroot** es una operación que cambia el directorio raíz aparente para un proceso. En FTP, esto significa que el usuario "cree" que su carpeta (ej. `/home/usuario/ftp`) es el directorio raíz `/`. No puede subir niveles con `cd ..`.

**Configuración en `vsftpd.conf`:**

* `chroot_local_user=YES`: Encierra a todos los usuarios locales en su *home*.
* `chroot_list_enable=YES`: Permite crear una lista de excepciones (usuarios que sí pueden navegar por todo el servidor).

### 4.3. Control de acceso por lista de usuarios

Podemos denegar el acceso a usuarios sensibles (como `root`) mediante el archivo `/etc/ftpusers`. Cualquier nombre que aparezca en esa lista tendrá el acceso prohibido aunque la contraseña sea correcta.

---

!!! note "🛠️ Práctica Guiada: Creación de un usuario de despliegue *enjaulado*"
    Vamos a crear un usuario específico para subir una web, asegurándonos de que no pueda salir de su carpeta.  
    1. **Crear el usuario sin acceso a shell (más seguro):**  
    `sudo adduser webdeveloper --shell /usr/sbin/nologin`  
    2. **Asignar una carpeta de trabajo (ej. para una web):**  
    `sudo mkdir -p /var/www/html/proyecto1`  
    `sudo chown webdeveloper:webdeveloper /var/www/html/proyecto1`  
    3. **Configurar vsftpd para apuntar al directorio correcto:**  
    Edita vsftpd.conf` y añade o modifica:  
        `user_sub_token=$USER`
        `local_root=/var/www/html/$USER`

    *(Esto hará que si entra el usuario 'webdeveloper', su raíz sea /var/www/html/webdeveloper)*.  
    4. **Reiniciar y Probar:**  
    `sudo systemctl restart vsftpd`  
    Intenta entrar con FileZilla y comprueba que no puedes navegar hacia carpetas superiores como `/etc` o `/var`.  

#### 📚 Recursos de interés

* **[Manual de Debian: Usuarios virtuales con vsftpd](https://wiki.debian.org/vsftpd){target=blank}**: Guía avanzada para gestionar usuarios sin crear cuentas de sistema.

## 5. Transferencia Segura de Archivos
El protocolo FTP original no cifra los datos, lo que significa que el nombre de usuario, la contraseña y el contenido de los archivos viajan en texto plano por la red.  
 Como administradores, debemos implementar capas de cifrado para proteger la integridad del despliegue.
Para evitar ataques de tipo *Man-in-the-Middle* o el olfateo de contraseñas, evolucionamos hacia protocolos que utilizan criptografía.

### 5.1. Debilidades del FTP tradicional

El FTP estándar usa el puerto 21 para todo. Si usamos un analizador de tráfico como Wireshark durante una sesión FTP normal, veríamos el comando `PASS` seguido de la contraseña en texto claro. Esto es inaceptable en entornos de producción.

### 5.2. FTPS (FTP over SSL/TLS)

Es la extensión segura del FTP. Utiliza certificados digitales (similares a los de HTTPS) para cifrar el canal de control y/o el de datos.

* **Explicit FTPS:** El cliente se conecta al puerto 21 y solicita explícitamente cifrar la conexión mediante el comando `AUTH TLS`. Es el más compatible.
* **Implicit FTPS:** La conexión se cifra desde el segundo uno, normalmente en el puerto 990. Se considera obsoleto en favor del modo explícito.

### 5.3. SFTP (SSH File Transfer Protocol)

A pesar de su nombre, **no es FTP**. Es un protocolo completamente distinto basado en **SSH (Secure Shell)**.

* **Puerto único:** Todo viaja por el puerto 22 (control y datos). Esto elimina los problemas de puertos pasivos y firewalls.
* **Seguridad:** Hereda toda la robustez de SSH. Permite autenticación por claves públicas/privadas (sin contraseña).
* **Configuración:** Si el servidor tiene SSH habilitado, normalmente SFTP ya está funcionando sin instalar nada adicional.


#### 📚 Recursos de interés

* **[OpenSSL Documentation](https://www.openssl.org/docs/){target=blank}:** Para profundizar en la creación y gestión de certificados.
* **[SSH.com - SFTP Guide](https://www.ssh.com/academy/ssh/sftp){target=blank}:** Explicación de por qué SFTP es preferible en la mayoría de flujos de trabajo de administración de sistemas.


!!! note "🛠️ Práctica Guiada: Configurando FTPS en vsftpd"
    Vamos a generar un certificado auto-firmado y obligar a nuestro servidor a usar TLS.

    1. **Generar el certificado:**

        ```bash
        sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
        ```

    2. **Configurar el servidor:** Ejecuta `sudo nano /etc/vsftpd.conf` y añade:

        ```bash
        # Activar SSL
        ssl_enable=YES
        allow_anon_ssl=NO
        force_local_data_ssl=YES
        force_local_logins_ssl=YES

        # Ruta de los certificados
        rsa_cert_file=/etc/ssl/private/vsftpd.pem
        rsa_private_key_file=/etc/ssl/private/vsftpd.pem
        ```

    3. **Reiniciar:** `sudo systemctl restart vsftpd`
    
    4. **Prueba de conexión:** Intenta conectar con FileZilla. Verás que ahora aparece un candado y un aviso preguntando si confías en el certificado generado.


!!! example "🎯 Actividades externas."
    Completa estos dos tutoriales.

    <div class="grid cards" markdown>

    -   :material-file-certificate: __Actividad A: DigitalOcean__
        ---
        Configurar vsftpd para usar SSL/TLS en Ubuntu.
        
        [:octicons-arrow-right-24: Acceso al tutorial](https://www.digitalocean.com/community/tutorials/how-to-configure-vsftpd-to-use-ssl-tls-on-an-ubuntu-vps){target=blank}

    -   :material-file-certificate: __Actividad B: DigitalOcean__
        ---
        Configurar vsftpd para utilizar el directorio de usuario en Ubuntu.
        
        [:octicons-arrow-right-24: Acceso al tutorial](https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-a-user-s-directory-on-ubuntu-20-04){target=blank}

    </div>


## 6. Clientes de transferencia y herramientas de administración

Un cliente FTP es el software que permite al usuario final o al administrador interactuar con el servidor para gestionar el sistema de archivos remoto.

### 6.1. Clientes en línea de comandos (CLI)

Es la forma más pura de interactuar con el servidor. Es esencial cuando administramos servidores sin entorno gráfico (headless).

* **`ftp`**: El cliente clásico. Útil para pruebas rápidas, pero no soporta cifrado de forma nativa en muchas versiones básicas.
* **`sftp`**: El estándar para transferencias seguras sobre SSH. Utiliza una sintaxis similar al comando `ftp` pero con toda la seguridad de SSH.
* **`scp` (Secure Copy)**: No es un cliente interactivo, sino un comando para copiar archivos de forma directa y rápida entre máquinas:
`scp archivo.zip usuario@ip_servidor:/ruta/destino`

### 6.2. Clientes gráficos (GUI)

Ofrecen una visión en paralelo del sistema de archivos local y el remoto, facilitando tareas de arrastrar y soltar.

* **FileZilla**: El cliente de código abierto más popular. Soporta FTP, FTPS y SFTP. Permite gestionar colas de transferencia y límites de velocidad.
* **WinSCP**: Excelente cliente para Windows que permite, además, editar archivos directamente en el servidor usando un editor de texto local, sincronizando los cambios automáticamente.
!!! note "🛠️ Práctica Guiada: Dominando la consola y el modo gráfico"
    Vamos a realizar la misma tarea (subir un archivo `index.html`) usando ambos métodos.

    🖥️ Tarea A: Usando SFTP (Consola)

    1. **Desde tu máquina real (o una terminal), conecta al servidor:**
            ```bash
            sftp usuario@dirección_ip
            ```
    2. **Navega al directorio de la web:**
            ```bash
            cd /var/www/html
            ```
    3. **Sube el archivo:**
            ```bash
            put index.html
            ```
    4. **Comprueba que está ahí:**
            ```bash
            ls -la
            ```
    5. **Sal:** `exit`

    🖱️ Tarea B: Usando FileZilla (Gráfico)

    1. **Crea un "Nuevo Sitio"** en el Gestor de Sitios.
    2. **En Protocolo**, selecciona *SFTP - SSH File Transfer Protocol*.
    3. **Introduce la IP, usuario y contraseña.**
        1. **Al conectar**, acepta la huella de la clave del servidor (ECDSA/RSA).
        2. **Arrastra un archivo** de tu panel izquierdo (local) al derecho (remoto).
### 6.3. Automatización de tareas

Como administradores de aplicaciones web, a veces necesitaremos programar copias de seguridad o despliegues automáticos. Herramientas como **`lftp`** permiten crear scripts complejos:

```bash
# Ejemplo de script para subir solo archivos nuevos
lftp -c "open -u usuario,password ip_servidor; mirror -R /carpeta/local /carpeta/remota"

```

---

#### 📚 Recursos de interés

* **[Documentación de WinSCP: Guía de uso](https://winscp.net/eng/docs/guides){target=blank}**: Tutoriales sobre sincronización de carpetas y edición remota.
* **[Manual de lftp](https://lftp.yar.ru/lftp-man.html){target=blank}**: Para aquellos que quieran profundizar en la automatización de espejos (mirrors) de sitios web.

## 7. Integración en el flujo de Despliegue de Aplicaciones Web

En el mundo real, los desarrolladores no suelen abrir un cliente externo como FileZilla cada vez que cambian una línea de código. La tendencia es integrar la transferencia directamente en las herramientas de trabajo diarias.

### 7.1. FTP/SFTP como método de despliegue desde el IDE

Los Entornos de Desarrollo Integrados (IDEs) como **Visual Studio Code**, **PHPStorm** o **Eclipse** permiten configurar conexiones remotas. Esto permite:

* **Sincronización al guardar:** Cada vez que el desarrollador pulsa `Ctrl+S`, el archivo se sube automáticamente al servidor de aplicaciones.
* **Edición remota:** Abrir y modificar archivos directamente en el servidor como si fueran locales.
* **Comparación de archivos (Diff):** Ver las diferencias entre la versión que tenemos en el ordenador y la que está publicada.

### 7.2. Servicios integrados en paneles de control y servidores web

Muchos servidores de aplicaciones o paneles de gestión (como **Plesk**, **cPanel** o el propio **Apache Tomcat**) ofrecen sus propios gestores de archivos web.

* **Web-based FTP:** Permiten subir archivos a través del navegador sin instalar ningún cliente.
* **Módulos de despliegue:** Tomcat, por ejemplo, permite desplegar archivos `.war` a través de su interfaz Manager, que internamente gestiona la transferencia y desempaquetado de la aplicación.

---

!!! note "🛠️ Práctica Guiada: Despliegue automático desde VS Code"

    Vamos a convertir nuestro editor en una herramienta de despliegue directo.  

    1. **Instalar extensión:** En VS Code, busca e instala la extensión **"SFTP"** (de liximomo o similares).  
   
    2. **Configurar el proyecto:** Abre una carpeta local con un `index.html`. Pulsa `Ctrl+Shift+P` y busca `SFTP: Config`.  
   
    3. **Editar `sftp.json`:** Rellena los datos de tu servidor:  
   
        ```json
        {  
            "name": "Servidor de Producción",  
            "host": "IP_DE_TU_SERVIDOR",  
            "protocol": "sftp",  
            "port": 22,  
            "username": "webdeveloper",  
            "remotePath": "/var/www/html/proyecto1",  
            "uploadOnSave": true  
        }  

        ```
    4. **Probar el flujo:** Cambia el título del `index.html`, guarda el archivo y comprueba en el navegador que el cambio se ha reflejado instantáneamente en el servidor.

### 7.3. Limitaciones y buenas prácticas

Aunque el FTP es cómodo para despliegues rápidos, en proyectos grandes tiene desventajas:

* **Falta de versionado:** Si subes un archivo por error, sobrescribes el anterior sin posibilidad sencilla de volver atrás (a menos que uses un sistema como Git).
* **Consistencia:** Si estás subiendo 100 archivos y la conexión se corta a la mitad, la web puede quedar en un estado "roto".

Por ello, el administrador debe documentar cuándo es aceptable usar FTP (hotfix rápidos, sitios estáticos) y cuándo se deben usar sistemas más robustos.

#### 📚 Recursos de interés

* **[VS Code SFTP Extension Wiki](https://github.com/liximomo/vscode-sftp/wiki){target=blank}:** Documentación detallada sobre cómo configurar filtros para no subir carpetas innecesarias (como `node_modules`).
* **[JetBrains: Deployment in PHPStorm](https://www.jetbrains.com/help/phpstorm/deploying-applications.html){target=blank}:** Guía profesional sobre cómo gestionar múltiples entornos (desarrollo, test, producción).

## 8. Despliegue avanzado: Virtualización, Contenedores y Nube

La modernización del despliegue busca que el servidor de archivos sea una pieza de infraestructura "desechable" y fácilmente reproducible.

### 8.1. Servidores de archivos en Docker

Desplegar un servidor FTP con Docker permite levantar el servicio en segundos sin ensuciar el sistema host con dependencias o archivos de configuración dispersos.

* **Aislamiento:** Cada contenedor tiene su propio sistema de archivos y red.
* **Persistencia (Volúmenes):** Es vital mapear las carpetas del contenedor (donde se suben los archivos) a carpetas del host para que, si el contenedor se borra, los archivos web no se pierdan.
* **Variables de Entorno:** Permiten configurar el usuario, la contraseña y el rango de puertos pasivos sin editar archivos `.conf` manualmente.

### 8.2. Almacenamiento y transferencia en la Nube

En entornos *Cloud*, a menudo delegamos la gestión del servidor al proveedor (AWS, Azure, Google Cloud) para ganar en escalabilidad elástica.

* **PaaS (Platform as a Service):** Servicios como *AWS Transfer Family* proporcionan puntos de enlace (endpoints) SFTP/FTPS que escalan automáticamente y guardan los archivos directamente en cubos de almacenamiento (S3).
* **Serverless Transfer:** No gestionamos procesos ni hilos; solo pagamos por los datos transferidos y el tiempo que el servicio está activo.

!!! note "🛠️ Práctica Guiada: Servidor FTP *instantáneo* con Docker Compose"

 
    Vamos a levantar un servidor funcional sin usar `apt install`.  

    1. **Crear el archivo `docker-compose.yml`:**
   
        ```bash  
            version: '3.3'  

            services:
              ftp:
                image: delfer/alpine-ftp-server
                container_name: ftp-server
                ports:
                  - "21:21"
                  - "21000-21010:21000-21010"
                environment:
                  - FTP_USER=admin
                  - FTP_PASS=password123
                  - ADDRESS=localhost
                  - MIN_PORT=21000
                  - MAX_PORT=21010
            volumes:
              - ./web_data:/home/admin/
        ```
    2. **Lanzar el servicio:** `docker-compose up -d`
    3. **Verificar:** Verás que ha aparecido una carpeta `web_data` en tu directorio actual. Todo lo que subas por FTP aparecerá en esta localización gracias al **volumen**.
    4. **Limpiar:** Para borrar todo el servidor, basta con un `docker-compose down`.
    
### 8.3. Comparativa de escenarios

| Escenario                      | Método recomendado     | Razón principal                                |
| ------------------------------ | ---------------------- | ---------------------------------------------- |
| **Desarrollo local**           | Docker                 | Rapidez y limpieza en la máquina del dev.      |
| **Producción (VM única)**      | vsftpd / SFTP          | Máximo control sobre los recursos del sistema. |
| **App de alta disponibilidad** | Cloud PaaS (AWS/Azure) | Escalabilidad y redundancia geográfica.        |

#### 📚 Recursos de interés

* **[Docker Hub - vsftpd images](https://hub.docker.com/r/fauria/vsftpd){target=blank}**: Catálogo de imágenes listas para usar.
* **[AWS Transfer Family](https://aws.amazon.com/es/aws-transfer-family/){target=blank}**: Información sobre cómo escalar SFTP en entornos corporativos.

## 9. Documentación y pruebas del servicio

En un entorno profesional de desarrollo de aplicaciones web, la fiabilidad se garantiza mediante pruebas sistemáticas y una documentación técnica impecable.

### 9.1. Pruebas de funcionamiento y carga (Benchmarking)

El administrador debe validar que el servidor no solo responde, sino que es estable frente a múltiples usuarios concurrentes.

* **Pruebas Funcionales:** Verificar el acceso en modo activo y pasivo, el correcto funcionamiento del cifrado TLS/SSL y que el enjaulamiento (*chroot*) impide efectivamente la salida del directorio raíz.
* **Pruebas de Estrés:** Utilizar herramientas para simular múltiples subidas y bajadas simultáneas.
* **Métricas críticas:** Tiempo medio de conexión, tasa de errores de transferencia y consumo de CPU/RAM durante picos de tráfico.


* **Validación de Cuotas:** Comprobar que el servidor bloquea nuevas subidas una vez alcanzado el límite de disco asignado al usuario.

### 9.2. Documentación Técnica de la Infraestructura

La documentación debe permitir que cualquier técnico entienda la topología del servicio en minutos. Siguiendo los estándares de la industria, utilizaremos **Markdown** para facilitar su control de versiones en repositorios como Git.

**Contenido mínimo obligatorio:**

1. **Ficha Técnica:** Versión del software, dirección IP, puertos abiertos y protocolo de seguridad utilizado (SFTP o FTPS).
2. **Esquema de Red:** Diagrama que muestre el flujo del tráfico desde el cliente hasta el servidor, incluyendo el firewall.
3. **Manual de Configuración:** Listado de archivos modificados (ej. `/etc/vsftpd.conf`) y el propósito de cada ajuste realizado.
4. **Matriz de Usuarios:** Definición de roles, permisos sobre directorios y límites de cuota asignados.

---

!!! note "🛠️ Práctica Guiada: Generando Documentación"

      Vamos a crear un documento de validación técnica rápido para nuestro servidor.

      1. **Validación de red:** 
   
        Ejecuta `netstat -tlnp`  
        Documenta los puertos que están a la escucha.

      2. **Prueba de acceso seguro:**   
        
        Intenta conectar por consola y verifica que el servidor rechaza conexiones no cifradas (si así se configuró).  
        `ftp -p IP_SERVIDOR` Debería fallar si obligamos a usar SSL.
        
      3. **Crea un archivo `README.md` con esta estructura markdown**
       

#### 📚 Recursos de interés

* **[Write the Docs - Guía de documentación técnica](https://www.writethedocs.org/guide/writing/beginners-guide-to-docs/){target=blank}**: Principios para escribir documentación útil para otros ingenieros.
* **[DigitalOcean - Cómo usar Benchmarking](https://www.digitalocean.com/community/tutorials/how-to-use-apachebench-to-do-load-testing-on-an-ubuntu-13-10-vps){target=blank}**: Aunque enfocado a web, los principios de carga son aplicables a servidores de archivos.
