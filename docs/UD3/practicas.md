# 🚀 Actividades. Administración de servidores de aplicaciones.

## 🏁 Escenario.
En estas prácticas, deberás gestionar un ecosistema de servicios que representen tu identidad profesional. Siguiendo las tendencias actuales del mercado laboral, tu portfolio se dividirá en tres microservicios independientes que deben convivir y cooperar en un mismo servidor.  
El portfolio debe estar compuesto por los siguientes tres módulos funcionales, cada uno corriendo en su propia tecnología:

1. **Módulo de Presentación (Node.js):** Página principal con el perfil profesional, fotografía, biografía técnica y listado visual de habilidades.
2. **Módulo de Proyectos/API (Python):** Un servicio que devuelva en formato JSON el listado de proyectos realizados (título, descripción, tecnologías y enlace a GitHub).
3. **Módulo de Blog/Artículos (PHP):** Sección FEOE, donde publiques las actividades que vienes desarrollando en la empresa.
---

## 1️⃣ Práctica 1: Motores y Entornos (Runtime Setup).

**🎯 Objetivo:** Preparar el servidor para ejecutar los tres módulos de forma aislada.

#### **🛠️ Tareas:**

* **Node.js:** Instalar el gestor de procesos **PM2** de forma global. Configurar el inicio de la aplicación principal, activar el **Modo Clúster** y asegurar que el servicio se inicie automáticamente tras un reinicio del sistema.
* **Python:** Crear un entorno virtual (`venv`) para el módulo de proyectos. Instalar las dependencias necesarias. Configurar el servidor **Gunicorn** para que escuche en `127.0.0.1:8000`.
* **PHP:** Crear un archivo de **Pool** específico para la FEOE en el directorio de configuración de PHP-FPM. Configurar el proceso para que utilice un **Unix Socket** en lugar de un puerto.

#### 🧪 Pruebas de verificación:

  * Ejecutar `pm2 status` y verificar que el proceso de Node está en `online`.
  * Ejecutar `curl -I http://127.0.0.1:8000` y confirmar respuesta del servidor Python.
  * Ejecutar `ls -l /run/php/` para comprobar que el archivo `.sock` del blog existe.

---

## 2️⃣ Práctica 2: Integración con Proxy Inverso (Nginx).

**🎯 Objetivo:** Unificar los tres módulos bajo una única dirección IP y puerto estándar (80).

#### **🛠️ Tareas:**

* **Configuración de VirtualHost:** Crear un archivo de sitio en Nginx que gestione el ruteo:
    * El tráfico a la raíz (`/`) debe redirigirse al servicio de Node.js.
    * El tráfico a `/api` debe redirigirse al servicio de Python.
    * El tráfico a `/feoe` debe procesarse mediante el socket de PHP-FPM.
* **Optimización de Recursos:** Configurar una ruta de **archivos estáticos** para que Nginx entregue directamente las imágenes de los proyectos y el PDF del CV sin consultar a los servidores de aplicaciones.
* **Cabeceras Proxy:** Configurar directivas `proxy_set_header` para que los servicios internos reciban la IP real del cliente.

**🧪 Pruebas de verificación:**

* Acceder desde el navegador a `http://<IP>/api` y comprobar que se visualiza el JSON de proyectos.
* Acceder a `http://<IP>/feoe` y comprobar que el motor PHP sirve el contenido del blog.
 
 ---

## **3️⃣ Práctica 3: Bastionado (Hardening) y Seguridad**

**🎯 Objetivo:** Proteger el portfolio aplicando estándares de seguridad empresarial.

#### 🛠️ Tareas:

* **Privilegios Mínimos:** Asegurar que cada servicio corre con un **usuario de sistema propio**, sin permisos de administración y sin acceso a consola (*shell*).
* **Certificado SSL:** Implementar cifrado **HTTPS** mediante un certificado (Let's Encrypt o auto-firmado) y configurar la redirección automática desde el puerto 80 al 443.
* **Ocultación de Huella:** Desactivar la cabecera `X-Powered-By` y ocultar las versiones de Nginx y PHP en todas las respuestas HTTP.
* **Firewall:** Cerrar todos los puertos del servidor excepto el 80, 443 y el puerto SSH para administración.

**🧪 Pruebas de verificación:**

* Ejecutar `curl -I https://<IP>` y verificar que no aparece el número de versión de Nginx.
* Comprobar con `netstat -tuln` que los puertos 3000 y 8000 no están escuchando en la IP pública, solo en `127.0.0.1`.

---

## **4️⃣ Práctica 4: Modernización con Docker Compose**

**🎯 Objetivo:** Convertir el portfolio en una infraestructura portable y reproducible.

#### 🛠️Tareas:**

* **Dockerización:** Crear archivos `Dockerfile` basados en imágenes ligeras ([tipo *Alpine*](https://hub.docker.com/_/alpine){target=blank}) para cada módulo del portfolio.
* **Orquestación:** Configurar un archivo `docker-compose.yml` que levante los tres servicios, una base de datos y el servidor Nginx de forma coordinada.
* **Persistencia:** Configurar **volúmenes** para asegurar que los artículos del blog y la base de datos no se borren al reiniciar los contenedores. Utilizar archivos `.env` para las credenciales.

**🧪 Prueba de verificación:**

* Ejecutar `docker-compose ps` y confirmar que todos los servicios están "Up".
* Realizar un cambio en el archivo `.env` y verificar que los contenedores lo aplican tras un reinicio.

---

## **5️⃣ Práctica 5: Monitorización y Rendimiento**

**🎯 Objetivo:** Validar que el portfolio es capaz de soportar tráfico real de reclutadores.

#### 🛠️ Tareas:**

* **Test de Carga:** Realizar una prueba de estrés enviando 50 peticiones simultáneas hasta completar 1000.
* **Análisis de Consumo:** Monitorizar el uso de RAM y CPU de los contenedores/procesos durante la prueba.
* **Gestión de Logs:** Configurar la rotación de logs para evitar que el disco se llene y analizar las peticiones que devuelvan errores 5xx.

**🧪 Pruebas de verificación:**

* Ejecutar `ab -n 1000 -c 50 http://<IP>/` y obtener un reporte con cero errores.
* Usar `docker stats` (o `top` en host) para identificar cuál de los tres módulos consume más recursos durante la prueba.

Para cerrar el diseño de la unidad, aquí tienes la estructura de **Entrega** detallada, siguiendo el estilo de la unidad anterior que me pasaste pero adaptada a este ecosistema políglota.

Esta sección define qué debe subir el alumno y en qué formato, asegurando que puedas evaluar tanto la parte técnica como la capacidad de documentación.

---

## 📂 Entrega

La entrega se realizará mediante un enlace a un **repositorio privado en GitHub/GitLab** que contenga la siguiente estructura de carpetas:

* `/src`: Código base de los 3 módulos (Node, Python, PHP).
* `/config`: Archivos de configuración (`nginx.conf`, pools de PHP-FPM, unidades de systemd o archivos de PM2).
* `/docker`: Dockerfiles y el archivo `docker-compose.yml`.
* `README.md`: La memoria técnica principal del proyecto.


#### 📝 Contenido de la Memoria Técnica (README.md)

El documento debe estar redactado en **Markdown** e incluir obligatoriamente:

1. **Esquema de Arquitectura:** Un diagrama que muestre el flujo de una petición desde que entra por el puerto 80/443 hasta que llega al servidor de aplicaciones correspondiente.
2. **Inventario de Servicios:** Tabla con tecnologías, versiones, puertos internos y sockets utilizados.
3. **Guía de Despliegue:** Pasos detallados para levantar el entorno desde cero (comandos de instalación, configuración de entornos virtuales y levantamiento de contenedores).
4. **Evidencias de Verificación:** Capturas de pantalla o bloques de código con el resultado de los **Checks de Verificación** de cada práctica (status de servicios, logs de éxito, etc.).
5. **Informe de Rendimiento:** Gráfica o tabla con los resultados del test de estrés realizado en la Práctica 5.
6. **Diario de Incidencias:** Descripción de al menos 2 problemas técnicos encontrados durante el proceso y cómo se resolvieron (basándose en la lectura de logs).
