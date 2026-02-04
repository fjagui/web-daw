# Actividades. Implantación de arquitecturas web
## Actividad 1: Análisis y fundamentos de arquitecturas web. (Criterios a, b, g, h)
### Descripción:
Esta actividad de investigación y análisis permitirá al alumnado familiarizarse con los distintos tipos de arquitecturas web existentes en el mercado, comprendiendo sus características, ventajas e inconvenientes. Se analizarán los protocolos de comunicación web y la estructura de una aplicación real, identificando todos los componentes necesarios para su correcto funcionamiento y los requisitos para su implantación.
### Tareas:  
1. **Investigación de arquitecturas:**  
      - Consulta de recursos previamente seleccionados sobre arquitecturas monolítica, cliente-servidor, microservicios y serverless.  
      - Análisis de casos de estudio reales de cada tipo de arquitectura.
2. **Análisis de protocolos web:**
      - Demostración práctica del flujo HTTP/HTTPS usando herramientas de desarrollador del navegador.
      - Ejercicio de resolución DNS y explicación de su funcionamiento.
3. **Estructura de aplicaciones:**
      - Descomposición de una aplicación WordPress preinstalada.
      - Identificación conjunta de componentes frontend, backend y base de datos

### Tareas propuestas:    

1. Tabla Comparativa de Arquitecturas (Criterio a)
      - Crear una tabla comparativa detallada que incluya:
         - Características técnicas de cada arquitectura (monolítica, cliente-servidor, microservicios, serverless).
         - Ventajas e inconvenientes.
         - Casos de uso recomendados para cada tipo.
         - Ejemplos reales de empresas que utilizan cada arquitectura

2. Análisis de Protocolos Web (Criterio b)
     - Investigar y explicar detalladamente:
         - Protocolos HTTP/HTTPS: diferencias, métodos (GET, POST, PUT, DELETE)
         - Códigos de estado HTTP (1xx, 2xx, 3xx, 4xx, 5xx) con ejemplos
         - Funcionamiento de cookies y sesiones
         - Proceso de resolución DNS y su importancia en las aplicaciones web

3. Estructura de Aplicación Web (Criterio g)  
      - Analizar una aplicación web existente (WordPress o similar) e identificar:
        - Componentes del frontend (HTML, CSS, JavaScript, frameworks)
        - Elementos del backend (lenguaje de programación, servidor de aplicaciones)
        - Recursos de base de datos (tipo, tablas principales)
        - Archivos estáticos y su gestión
        - Diagrama de componentes de la aplicación

4. Requerimientos de Implantación (Criterio h)
      - Elaborar una lista completa de requerimientos para implantar la aplicación analizada:
          - Hardware: requisitos de CPU, RAM, almacenamiento
          - Software: sistema operativo, servidor web, servidor de aplicaciones, gestor de bases de datos
          - Dependencias: librerías, frameworks, versiones específicas
          - Configuración: permisos de archivos, usuarios, servicios
          - Red y dominio: configuración DNS, certificados SSL, puertos
### Entrega:
- Documento de análisis completo en formato PDF que incluya:
      - Portada con datos del alumno y título de la actividad
      - Tabla comparativa de arquitecturas
      - Explicación de protocolos web con diagramas propios
      - Análisis estructural de la aplicación con diagrama de componentes
      - Lista detallada de requerimientos de implantación
      - Conclusiones personales sobre lo aprendido

- Carpeta con recursos adicionales:
      - Capturas de pantalla del análisis de la aplicación
      - Diagramas en formato editable (si se utilizaron herramientas de diagramación)
      - Bibliografía consultada


## Actividad 2: Instalación, configuración y funcionamiento básico de servidores web. (Criterios c,f,i)

### Actividad 2.1: "Servidor Web con NGINX"
#### Descripción.
Familiarizarse con la instalación, configuración y uso básico de **NGINX** como servidor web para el despliegue de aplicaciones.

#### Tareas
 **1.-** Comprueba la **disponibilidad del puerto 80**.  
Antes de instalar NGINX, debemos asegurarnos de que el **puerto 80** no esté ocupado por otro servicio (por ejemplo, por **Apache**).  
```bash
sudo lsof -i :80
```  
Si no aparece nada, significa que el puerto está libre.  
Si aparece un servicio como `apache2` o `httpd`, significa que ya tienes el puerto ocupado y deberás detenerlo temporalmente para trabajar con NGINX o utilizar un puerto diferente:  

```bash
sudo systemctl stop apache2
```
     
**2.- Instalación de NGINX**.  
En sistemas basados en **Debian/Ubuntu**:

```bash
sudo apt update
sudo apt install nginx -y
```

**3.- Verificación del servicio.**  
Comprueba que NGINX está en ejecución:

```bash
  systemctl status nginx
```

Abre un navegador y accede a `localhost` o a la dirección IP del servidor.

``` bash
http://localhost
```

Debería aparecer la página de bienvenida de NGINX.  

**4.- Estructura de archivos y directorios**  
Localiza los siguientes archivos de configuración:

* `/etc/nginx/nginx.conf` (configuración principal)
* `/etc/nginx/sites-available/` (sitios disponibles)
* `/etc/nginx/sites-enabled/` (sitios habilitados)

El contenido web por defecto se encuentra en:

* `/var/www/html`

**5.- Crear una página web simple**

Edita y personaliza el archivo de inicio.

``` html
<!DOCTYPE html>
<html>
<head>
    <title>Mi primer sitio con NGINX</title>
</head>
<body>
    <h1>¡Hola, mundo desde NGINX!</h1>
</body>
</html>
```
Refresca la página en el navegador para comprobar los cambios.

#### Tareas propuestas. 

**1.- Verificación del estado del servicio**

  - Comprobar si Nginx está instalado y en ejecución.
  - Verificar el estado detallado del servicio.
  - Consultar los logs del servicio para detectar posibles errores

**2.- Control del ciclo de vida del servicio**

  - Iniciar el servicio Nginx
  - Detener el servicio Nginx
  - Reiniciar el servicio por completo
  - Recargar la configuración sin interrumpir las conexiones activas

**3.- Configuración de arranque automático**

  - Habilitar el inicio automático de Nginx al arrancar el sistema.
  - Deshabilitar el inicio automático.
  - Verificar la configuración de arranque

#### Entrega.
   Redacta y publica memoria del desarrollo de las prácticas. Incluye dificultades encontradas y un análisis de las aplicaciones reales que podrías desplegar usando NGINX.

### Actividad 2.2: "Servidor Web con Apache HTTP Server"
#### Descripción
Familiarizarse con la instalación, configuración y uso básico de **Apache HTTP Server** como servidor web para el despliegue de aplicaciones.

#### Tareas
**1.- Comprueba la disponibilidad del puerto 80.**  
Antes de instalar Apache, debemos asegurarnos de que el **puerto 80** no esté ocupado por otro servicio (por ejemplo, por **NGINX**).  
```bash
sudo lsof -i :80
```
Si no aparece nada, significa que el puerto está libre.
Si aparece un servicio como nginx u otro, significa que ya tienes el puerto ocupado y deberás detenerlo temporalmente para trabajar con Apache o utilizar un puerto diferente:
```bash
bash
sudo systemctl stop nginx
```
**2.- Instalación de Apache HTTP Server.**
En sistemas basados en Debian/Ubuntu:
```bash
sudo apt update
sudo apt install apache2 -y
```
**3.- Verificación del servicio.**
Comprueba que Apache está en ejecución:
```bash
systemctl status apache2
```
Abre un navegador y accede a localhost o a la dirección IP del servidor.
```bash
http://localhost
```
Debería aparecer la página de bienvenida de Apache por defecto.

**4.- Estructura de archivos y directorios.**  
Localiza los siguientes archivos de  configuración:

* `/etc/apache2/apache2.conf (configuración principal)`
* `/etc/apache2/sites-available/ (sitios disponibles)`
* `/etc/apache2/sites-enabled/ (sitios habilitados)`
* `/etc/apache2/ports.conf (configuración de puertos)`

El contenido web por defecto se encuentra en:

* `/var/www/html`

**5.- Crear una página web simple**

Edita y personaliza el archivo de inicio por defecto.

```bash
sudo nano /var/www/html/index.html
```
Inserta un HTML sencillo:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Mi primer sitio con Apache</title>
</head>
<body>
    <h1>¡Hola, mundo desde Apache HTTP Server!</h1>
    <p>Servidor funcionando correctamente</p>
</body>
</html>
```
Refresca la página en el navegador para comprobar los cambios.
#### Tareas propuestas
**1.- Verificación del estado del servicio**

  - Comprobar si Apache está instalado y en ejecución
  - Verificar el estado detallado del servicio
  - Consultar los logs del servicio para detectar posibles errores

**2.- Control del ciclo de vida del servicio**

  - Iniciar el servicio Apache
  - Detener el servicio Apache
  - Reiniciar el servicio por completo
  - Recargar la configuración sin interrumpir las conexiones activas

**3.- Configuración de arranque automático**

  - Habilitar el inicio automático de Apache al arrancar el sistema
  - Deshabilitar el inicio automático (solo para práctica)
  - Verificar la configuración de arranque

#### Entrega

Redacta y publica memoria del desarrollo de las prácticas. Incluye dificultades encontradas y un análisis de las aplicaciones reales que podrías desplegar usando Apache.  

## Actividad 3: Instalación, configuración y funcionamiento básico de servidores de aplicaciones. (Criterios d,f,i)
### Actividad 3.1: Despliegue de Aplicación Web en Apache Tomcat
#### Descripción
Familiarizarse con la instalación, configuración y uso básico de **Apache Tomcat** como servidor web para el despliegue de aplicaciones Java en un entorno **headless** (sin entorno gráfico).
#### Tareas

**1.- Comprobar la disponibilidad del puerto 8080.**
Tomcat escucha por defecto en el puerto **8080** para HTTP. Antes de instalarlo, debemos asegurarnos de que el puerto no esté ocupado por otro servicio:

```bash
sudo lsof -i :8080
```

Si no aparece nada, significa que el puerto está libre.
Si aparece un servicio, debes detenerlo o cambiar la configuración de Tomcat:

```bash
sudo systemctl stop tomcat10
```
**2.- Instalación de Java (OpenJDK headless).**
Tomcat requiere Java para funcionar. En Debian 13, instalamos la versión headless (sin componentes gráficos):

```bash
sudo apt update
sudo apt install openjdk-25-jdk-headless -y
```

Verifica la instalación:

```bash
java -version
```
**3.- Instalación de Tomcat 10.**
Instalamos Tomcat desde los repositorios oficiales:

```bash
sudo apt install tomcat10 -y
```

Iniciamos y habilitamos el servicio:

```bash
sudo systemctl start tomcat10
sudo systemctl enable tomcat10
```

Verifica el estado:

```bash
sudo systemctl status tomcat10
```

**4.- Crear una aplicación web simple ("Hola Mundo").**

1. Crear el directorio de la aplicación:

```bash
sudo mkdir -p /var/lib/tomcat10/webapps/hola
```

2. Crear el archivo `index.jsp`:

```bash
sudo nano /var/lib/tomcat10/webapps/hola/index.jsp
```

Contenido:

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Hola Mundo</title>
</head>
<body>
    <h1>¡Hola Mundo desde Tomcat!</h1>
</body>
</html>
```

3. Ajustar permisos:

```bash
sudo chown -R tomcat:tomcat /var/lib/tomcat10/webapps/hola
```

4. Reiniciar Tomcat para asegurar que cargue la nueva aplicación:

```bash
sudo systemctl restart tomcat10
```

---

**5.- Acceso a la aplicación.**
Desde el servidor o un navegador en la misma red:

```
http://IP_DEL_SERVIDOR:8080/hola/
```

**6.- Estructura de archivos y directorios importantes de Tomcat**

* `/etc/tomcat10/` → archivos de configuración principales (`server.xml`, `tomcat-users.xml`)
* `/var/lib/tomcat10/webapps/` → directorio donde se despliegan las aplicaciones `.war` o carpetas web
* `/var/log/tomcat10/` → logs del servidor

---

#### Tareas propuestas

**1.- Verificación del estado del servicio**

* Comprobar que Tomcat está instalado y en ejecución.
* Consultar los logs para detectar posibles errores:

**2.- Control del ciclo de vida del servicio**

* Iniciar el servicio Tomcat:
* Detener el servicio:
* Reiniciar el servicio:
* Recargar la configuración sin interrumpir conexiones activas:

#### Entrega

Redacta y publica memoria del desarrollo de la práctica. Incluye:

* Dificultades encontradas.
* Explicación de la estructura de Tomcat y la aplicación desplegada.
* Posibles aplicaciones reales que podrías desplegar usando Tomcat, como servicios web Java, APIs REST, o aplicaciones web dinámicas.


### Actividad 3.2: Despliegue de Aplicación Node.js con PM2 como Servidor de Aplicaciones

#### Descripción.

Familiarizarse con la instalación, configuración y uso básico de **Node.js** y **PM2** para desplegar aplicaciones JavaScript.

#### Tareas

**1.- Comprobar la disponibilidad del puerto 3000 (u otro puerto que vayas a usar).**
Node.js sirve por defecto en el **puerto 3000**. Antes de desplegar tu aplicación, asegúrate de que el puerto elegido esté libre:

**2.- Instalación de Node.js y npm.**

Instalamos la versión LTS de Node.js usando los repositorios oficiales:

```bash
sudo apt update
sudo apt install nodejs npm -y
```

Verifica la instalación:

```bash
node -v
npm -v
```

**3.- Instalación de PM2**
PM2 es un gestor de procesos para aplicaciones Node.js que permite ejecutarlas como servicios:

```bash
sudo npm install -g pm2
```

Verifica que PM2 esté disponible:

```bash
pm2 -v
```

**4.- Crear una aplicación Node.js simple**

1. Crea un directorio para tu aplicación:

```bash
mkdir ~/miapp
cd ~/miapp
```

2. Inicializa la aplicación:

```bash
npm init -y
```

3. Crea un archivo `app.js`:

```bash
nano app.js
```

Contenido de ejemplo:

```javascript
const http = require('http');

const port = 3000;

const requestHandler = (req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('¡Hola Mundo desde Node.js y PM2!\n');
};

const server = http.createServer(requestHandler);

server.listen(port, () => {
  console.log(`Servidor escuchando en http://localhost:${port}`);
});
```

Guarda y cierra el archivo.

**5.- Ejecutar la aplicación con PM2**

```bash
pm2 start app.js --name miapp
```

* `--name miapp` permite identificar el proceso fácilmente.

Verifica que la aplicación esté corriendo:

```bash
pm2 list
pm2 logs miapp
```

**6.- Configurar PM2 para reinicio automático**

Para que la aplicación se inicie automáticamente al reiniciar el servidor:

```bash
pm2 startup systemd
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER --hp $HOME
pm2 save
```

**7.- Acceso a la aplicación**

Abre un navegador desde otra máquina en la misma red:

```bash
http://IP_DEL_SERVIDOR:3000
```

#### Tareas propuestas

**1.- Verificación del estado del servicio**

* Comprobar que la aplicación Node.js está en ejecución con PM2.
* Consultar los logs para detectar posibles errores:
  
**2.- Control del ciclo de vida del servicio.**
  * Iniciar la aplicación
  * Detener la aplicación:
  * Reiniciar la aplicación:
  * Eliminar la aplicación de PM2:

**3.- Configuración de arranque automático**  

  * Habilitar inicio automático al arrancar el sistema.
  * Deshabilitar inicio automático.
  * Verificar configuración de arranque.

#### Entrega

Redacta y publica memoria del desarrollo de la práctica. Incluye:

* Dificultades encontradas.
* Explicación de la estructura de la aplicación Node.js y su despliegue con PM2.
* Posibles aplicaciones reales que podrías desplegar usando Node.js y PM2, como APIs REST, microservicios o aplicaciones web en tiempo real.




## Actividad 4: Instalación, configuración y funcionamiento básico de servicios web virtualizados. (Criterios e,f,i)

### Actividad 4.1: Virtualización de servicos web con contenedores.

#### Descripción.

Familiarizarse con la instalación, configuración y uso básico de **Docker** para desplegar un **servicio web**.

#### Tareas

**1.- Comprobar la disponibilidad de Docker en el sistema**
Antes de instalar Docker, verifica si ya está instalado:

```bash
docker --version
```

**2.- Instalación de Docker**

[Accede a la documentación](https://docs.docker.com/engine/install/){target=blank}  

**3.- Verifica la instalación:**

```bash
docker --version
```

**4.- Crear una página web estática.**

Contenido:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Hola Mundo Docker</title>
</head>
<body>
    <h1>¡Hola Mundo desde un contenedor Docker!</h1>
</body>
</html>
```

---

**4.- Crear un Dockerfile usando Nginx**

```bash
nano Dockerfile
```

Contenido:

```dockerfile
# Imagen base: Nginx ligera
FROM nginx:alpine

# Copiar la página estática al directorio que sirve Nginx
COPY index.html /usr/share/nginx/html/index.html

# Exponer el puerto 80
EXPOSE 80
```

**5.- Construir la imagen Docker**

```bash
docker build -t holamundo-web .
```

**6.- Ejecutar el contenedor**

```bash
docker run -d -p 8080:80 --name contenedor-holamundo-web holamundo-web
```

* `-d` → ejecuta en segundo plano
* `-p 8080:80` → mapea el puerto 80 del contenedor al puerto 8080 del host

Verifica que el contenedor está corriendo:

```bash
docker ps
```

**7.- Acceso a la página web**

En un navegador, accede a:

```bash
http://IP_DEL_SERVIDOR:8080
```

#### Tareas propuestas

**1.- Verificación del estado del contenedor**

* Listar contenedores en ejecución:
* Consultar logs del contenedor:

**2.- Control del ciclo de vida del contenedor**

* Detener el contenedor:
* Iniciar el contenedor nuevamente:
* Reiniciar el contenedor:
* Eliminar el contenedor:


**3.- Gestión de imágenes Docker**

* Listar imágenes disponibles:
* Eliminar imagen:

#### Entrega

Redacta y publica memoria del desarrollo de la práctica. Incluye:

* Dificultades encontradas durante la instalación de Docker y despliegue del contenedor.
* Explicación de la estructura del contenedor y de la página web dentro del entorno virtualizado.
* Posibles aplicaciones reales que podrías desplegar usando Docker, como sitios estáticos, microservicios, APIs web o entornos reproducibles de desarrollo.

### Actividad 4.2: Virtualización de servicos web en la nube con AWS.

#### Descripción.

Familiarizarse con la creación y configuración de una **instancia virtual en AWS (EC2)** y desplegar un **servicio web**.

#### Tareas

**1.- Crear una instancia EC2 en AWS**

1. Inicia sesión en tu cuenta de AWS.

2. Navega a **EC2 → Instancias → Lanzar instancia**.

3. Configura los siguientes parámetros básicos:

   * **AMI (Amazon Machine Image):** Debian 13 (Trixie) o Ubuntu 22.04 LTS
   * **Tipo de instancia:** t2.micro (gratuita si aplica)
   * **Par de llaves:** crea o usa uno existente para acceso SSH
   * **Grupo de seguridad:** habilita **HTTP (puerto 80)** y **SSH (puerto 22)**

4. Lanza la instancia y anota la **dirección IP pública**.

**2.- Conectarse por SSH a la instancia**

```bash
ssh -i /ruta/a/tu-llave.pem usuario@IP_PUBLICA
```

**3.- Actualizar paquetes e instalar Nginx**

```bash
sudo apt update
sudo apt install nginx -y
```

**4.- Verificar que Nginx funciona**

* Inicia Nginx:

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

* Verifica el estado:

```bash
sudo systemctl status nginx
```

* Desde el navegador, prueba:

```bash
http://IP_PUBLICA
```

**5.- Crear una página web estática.**

1. Edita el archivo por defecto de Nginx:
2. Sustituye el contenido por:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Hola Mundo AWS</title>
</head>
<body>
    <h1>¡Hola Mundo desde una instancia EC2 en AWS!</h1>
</body>
</html>
```

3. Guarda y cierra el archivo.
4. Reinicia Nginx para aplicar cambios:

**6.- Verificar la página**

* Desde cualquier navegador, accede a:

```bash
http://IP_PUBLICA
```

#### Tareas propuestas

**1.- Verificación del servicio**

  * Comprobar que Nginx está activo y funcionando.
  * Consultar logs de Nginx.

**2.- Control del ciclo de vida del servicio**

  * Iniciar, detener, reiniciar y recargar Nginx.

**3.- Seguridad y acceso**

  * Verificar reglas del **grupo de seguridad** para asegurar que el puerto 80 esté abierto.
  * Probar acceso desde otra máquina en la misma red o desde Internet.

#### Entrega

Redacta y publica memoria del desarrollo de la práctica. Incluye:

* Dificultades encontradas durante la creación de la instancia EC2 y la instalación de Nginx.
* Explicación de la estructura de la instancia, la página web y la configuración de seguridad.
* Posibles aplicaciones reales que podrías desplegar en la nube, como sitios estáticos, APIs, microservicios o entornos de desarrollo y pruebas.
