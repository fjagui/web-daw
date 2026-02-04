
# 🧩 Administración de servidores web.

## **1️⃣ Práctica 1: Administración y configuración de Apache HTTP Server**

### **Descripción**

El alumnado configurará un servidor web Apache capaz de alojar múltiples sitios virtuales con distintos niveles de seguridad y autenticación.
El objetivo es comprender la administración, personalización y aseguramiento del servicio web mediante configuración modular y buenas prácticas.
---
### **Contexto**

Se trabajará con dos sitios distintos:

* **centroscivicos..local** → portal institucional protegido mediante autenticación básica.
* **portfolio.local** → sitio personal accesible mediante conexión segura (HTTPS).

---

### **Tareas**

1. **Reconocimiento de administración** (CE: a)  

      - Identifica los archivos y parámetros principales de configuración de Apache.
      - Explica las directivas más relevantes en seguridad, rendimiento y logs.

2. **Activación de módulos** (CE: b)

     - Investiga los módulos que amplían las funcionalidades del servidor (por ejemplo, `mod_ssl`, `mod_rewrite`).
     - Documenta su utilidad e impacto.

3. **Creación de sitios virtuales** (CE: c)

      * Crea los archivos y estructura de directorios necesarios para ambos sitios.
      * Configura los `VirtualHost` con nombres, logs y permisos adecuados.

4. **Autenticación y control de acceso** (CE: d)

      * Implementa autenticación básica para el sitio institucional.
      * Documenta el funcionamiento del mecanismo de control de acceso.

5. **Certificados y HTTPS (e, f)** (CE: e,f)

      * Genera un certificado digital para el sitio personal.
      * Configura el acceso HTTPS y verifica la conexión segura.

6. **Documentación y buenas prácticas** (CE: g,h)

      * Expón medidas adicionales de seguridad (ocultar versión, limitar métodos, etc.).
      * Redacta una memoria explicativa del proceso realizado.

---

### **Entrega**

* Memoria técnica con configuraciones y capturas.
* Comprobaciones de acceso a ambos sitios.
* Esquema de arquitectura y medidas de seguridad aplicadas.

---
## **2️⃣ Práctica 2: Administración y configuración de NGINX**
### **Descripción**
En esta práctica el alumnado configurará **NGINX** como servidor web, proxy inverso y balanceador de carga, aplicando medidas de seguridad y monitorización.
Se pretende consolidar el uso de NGINX como infraestructura de despliegue eficiente y segura.
---
### **Contexto**

* **protectoramascotas.local** → sitio institucional.
* **gestortareas.local** → aplicación interna servida mediante proxy inverso y balanceo de carga.

---

### **Tareas**

1. **Parámetros de administración**(CE:a)

      * Identifica los archivos y bloques de configuración más relevantes (`server`, `location`, `upstream`).
      * Explica las directivas de logs y rendimiento.

2. **Funcionalidades adicionales**(CE:b)

      * Activa funciones como compresión, cacheo y proxy.
      * Describe su contribución al rendimiento y seguridad.

3. **Sitios virtuales**(CE: c)

      * Diseña y configura los bloques de servidor para ambos dominios.

4. **Configuración HTTPS**(CE: e,f)

      * Implementa HTTPS en el sitio interno con certificados digitales.
      * Fuerza redirección segura y aplica cabeceras de seguridad.

5. **Proxy inverso y balanceo**(CE: h)

      * Configura NGINX como proxy inverso y crea un bloque `upstream` para balanceo.
      * Analiza los resultados y justifica el algoritmo usado.

6. **Monitorización y documentación** (CE: g,j)

      * Describe los principales archivos de log y analiza sus entradas.
      * Propón buenas prácticas para administración en producción.

---

### **Entrega**

* Memoria con configuraciones comentadas.
* Capturas de funcionamiento de los dos sitios.
* Diagrama de proxy inverso y balanceo.

---

## **3️⃣ Práctica 3: Despliegue de aplicaciones web mediante virtualización y contenedores**

### **Descripción**

El alumnado aprenderá a desplegar aplicaciones web utilizando tecnologías de contenedores y servicios en la nube, garantizando un entorno reproducible y seguro.
Se trabajará con tres escenarios prácticos que reflejan entornos reales de despliegue moderno.

---

### **Actividad 3.1: Instalación y despliegue local de Moodle en contenedores**

**Criterios:** h, i, g

1. Diseña la arquitectura de Moodle especificando los servicios necesarios (web, BD, red, volúmenes).
2. Utiliza Docker para desplegar la aplicación Moodle.
3. Documenta el proceso.

---

### **Actividad 3.2: Creación, empaquetado y distribución de una aplicación personalizada**

**Criterios:** h, i, g, j

1. Desarrolla una aplicación web sencilla.
2. Crea un **Dockerfile** para empaquetarla.
3. Publica el proyecto en **GitHub** con documentación técnica.
4. Sube la imagen al registro (**Docker Hub** o **GitHub Container Registry**).
5. Configura un flujo **CI/CD** con **GitHub Actions**.
6. Analiza logs de ejecución del contenedor y explica cómo monitorizarlos.

---

### **Actividad 3.3: Despliegue de un sitio personal con WordPress en AWS**

**Criterios:** f, g, h, i

1. Investiga opciones de despliegue de WordPress en AWS: **EC2**, **Lightsail** o **ECS**.
2. Despliega WordPress para un contexto personal.
3. Implementa medidas de seguridad: HTTPS, cortafuegos, control de acceso.
4. Documenta la instalación con capturas y un diagrama de arquitectura.
5. Compara ventajas entre despliegue local y en la nube.


---

### **Entrega**

* Memoria en PDF con todas las actividades.
* Diagramas y capturas del entorno Docker y AWS.
* Análisis comparativo entre los tres entornos de despliegue.

---

## **4️⃣ Práctica 4: Implantación segura y monitorización del servidor web**

---

### **Descripción**

Se trabajará la **supervisión, análisis y control del rendimiento** del servidor web, aplicando medidas de seguridad y herramientas de monitorización.

---

### **Tareas**

1. Activa y configura logs de acceso y error (CE: j).
2. Analiza registros con herramientas como **GoAccess** o **Logwatch**.
3. Implementa directivas de seguridad (cabeceras HSTS, CSP, etc.) (CE: f).
4. Configura comprobaciones básicas de estado (módulo `stub_status`, comandos `curl`).
5. Redacta un informe con los resultados del análisis (CE: g).

---

### **Entrega**

* Informe de monitorización y logs.
* Evidencias gráficas y conclusiones.

---

## **5️⃣ Práctica 5: Documentación y auditoría técnica del despliegue**

---

### **Descripción**

El alumnado elaborará la documentación técnica completa del despliegue y administración de servidores Apache y NGINX, incluyendo aspectos de seguridad, virtualización y monitorización.

---

### **Tareas**

1. Redacta un documento técnico con las configuraciones implementadas (CE: g).
2. Incluye diagramas de red, flujos de peticiones y topología de despliegue (CE: h).
3. Explica las tecnologías de contenedores o virtualización utilizadas (CE: i).
4. Incorpora ejemplos reales de logs y su interpretación (CE: j).
5. Propón buenas prácticas para mantener el servidor actualizado y seguro.

---

### **Entrega**

* Documento técnico final Markdown.
* Diagramas, capturas y ejemplos de configuración.
* Conclusiones personales sobre la gestión segura de servidores web.

---

## ✨ **Conclusión**

Estas prácticas permiten al alumnado desarrollar de forma progresiva todas las competencias necesarias para implantar, administrar y asegurar aplicaciones web modernas.
Desde la configuración de servidores hasta el despliegue en contenedores y la nube, el conjunto abarca los criterios **a–j** del resultado de aprendizaje completo.

