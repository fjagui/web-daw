
# Administración de servidores web.

## 🔸 Introducción

Los servidores web son el punto de entrada a la mayoría de las aplicaciones que desplegamos. Su correcta configuración no solo garantiza que las aplicaciones funcionen, sino también que lo hagan de forma **segura, eficiente y monitorizable**.

En esta unidad se estudian dos de los servidores más utilizados en el mundo profesional:

* **[Apache HTTP Server](https://httpd.apache.org/){target='_blank'}**, conocido por su modularidad y compatibilidad.
* **[NGINX](https://nginx.org/en/docs/){target='_blank'}**, famoso por su rendimiento y capacidad de actuar como proxy inverso y balanceador.

El objetivo de esta unidad es que el alumnado sea capaz de:

1. Configurar y administrar servidores web.
2. Implantar medidas de seguridad y control de acceso.
3. Desplegar aplicaciones web reales.
4. Monitorizar y analizar el funcionamiento del servidor.
5. Documentar correctamente todo el proceso.

---

## 1️⃣ Configuración y administración de servidores web

### 1.1. Instalación y estructura

En los sistemas **Debian**, tanto Apache como NGINX pueden instalarse fácilmente desde los repositorios oficiales:

```bash
sudo apt update
sudo apt install apache2
sudo apt install nginx
```

Una vez instalados, los servicios se gestionan con [**systemd**](https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units-es){target="_blank"}:

```bash
sudo systemctl start nginx
sudo systemctl enable apache2
sudo systemctl status nginx
```

🔹 **Ubicación típica de configuraciones:**

| Servidor | Directorio principal | Sitios disponibles              | Sitios activos                | Logs                |
| -------- | -------------------- | ------------------------------- | ----------------------------- | ------------------- |
| Apache   | `/etc/apache2/`      | `/etc/apache2/sites-available/` | `/etc/apache2/sites-enabled/` | `/var/log/apache2/` |
| NGINX    | `/etc/nginx/`        | `/etc/nginx/sites-available/`   | `/etc/nginx/sites-enabled/`   | `/var/log/nginx/`   |

Cada sitio web se define en un archivo dentro de `sites-available/`. Para activarlo:

```bash
sudo a2ensite nombre.conf      # Apache
sudo ln -s /etc/nginx/sites-available/nombre.conf /etc/nginx/sites-enabled/  # NGINX
```
📝 Configura apache y NGINX para que escuchen puertos diferentes.
### 1.2. Virtual Host

Los **sitios virtuales** permiten alojar varios proyectos o dominios en el mismo servidor.
Por ejemplo:

* `protectoramascotas.local` 
* `gestortareas.local` 

**Ejemplo NGINX:**

```nginx
server {
  listen 80;
  server_name protectoramascotas.local;
  root /var/www/protectoramascotas.local;
}
```  
↗️ [Actividad externa](https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-16-04){target='_blanck'}

**Ejemplo Apache:**

```apache
<VirtualHost *:80>
  ServerName protectoramascotas.local
  DocumentRoot /var/www/protectoramascotas.local
</VirtualHost>
```

↗️ [Actividad externa](https://www.digitalocean.com/community/tutorials/como-configurar-virtual-hosts-de-apache-en-ubuntu-16-04-es){target='_blanck'}

🔗 **Referencias:**  

  - [Apache Virtual Hosts](https://httpd.apache.org/docs/current/vhosts/){target='_blank'}
  - [NGINX Server Blocks](https://nginx.org/en/docs/http/request_processing.html){target='_blank'}

---

## 2️⃣ Seguridad y control de acceso

### 2.1. HTTPS y certificados digitales

La principal medida de seguridad en un servidor web es el **cifrado de las comunicaciones** mediante **TLS (HTTPS)**.
Para activarlo, se necesita un **certificado digital**, que puede ser:

* **Autofirmado** (para pruebas o entornos educativos).
* **Emitido por una autoridad de certificación (CA)**, como [Let’s Encrypt](https://letsencrypt.org/).

**Ejemplo NGINX:**

```nginx
server {
  listen 443 ssl;
  server_name gestortareas.local;

  ssl_certificate     /etc/ssl/certs/gestortareas.crt;
  ssl_certificate_key /etc/ssl/private/gestortareas.key;
}
```

**Prueba rápida del cifrado:**

```bash
curl -kI https://gestortareas.local
```

(`-k` permite ignorar certificados autofirmados durante las pruebas.)

↗️ [Actividad externa](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-20-04-es){target='_blanck'}

🔗 **Referncias:**

* [Apache mod_ssl Documentation](https://httpd.apache.org/docs/current/mod/mod_ssl.html)
* [NGINX HTTPS Servers](https://nginx.org/en/docs/http/configuring_https_servers.html)

---

### 2.2. Autenticación básica y control de acceso

En muchos entornos internos (por ejemplo, un portal de administración o una intranet) se requiere **autenticación por usuario y contraseña**.

En **Apache**, se usa el módulo `mod_auth_basic`; en **NGINX**, directivas como `auth_basic` y `auth_basic_user_file`.

**Ejemplo NGINX:**

```nginx
location /admin/ {
  auth_basic "Área restringida";
  auth_basic_user_file /etc/nginx/.htpasswd;
}
```

**Ejemplo Apache:**

```apache
<Directory "/var/www/protectoramascotas.local/privado">
  AuthType Basic
  AuthName "Zona restringida"
  AuthUserFile /etc/apache2/.htpasswd
  Require valid-user
</Directory>
```

↗️ [Actividad externa](https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-apache-on-ubuntu-18-04-es){target='_blanck'}

🔗 **Referencias:**

* [Apache Authentication Guide](https://httpd.apache.org/docs/current/howto/auth.html){target='_blank'}
* [NGINX Auth Basic](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html)

---

### 2.3. Seguridad del servidor

Algunas recomendaciones para proteger los servidores:

| Medida                       | Apache                                               | NGINX                                   |
| ---------------------------- | ---------------------------------------------------- | --------------------------------------- |
| Ocultar versión del servidor | `ServerTokens Prod` / `ServerSignature Off`          | `server_tokens off;`                    |
| Limitar tamaño de peticiones | `LimitRequestBody`                                   | `client_max_body_size 10m;`             |
| Forzar HTTPS                 | `RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI}` | `return 301 https://$host$request_uri;` |
| Cabeceras de seguridad       | `Header always set`                                  | `add_header`                            |

↗️ [Actividad externa.](https://www.digitalocean.com/community/tutorials/recommended-steps-to-harden-apache-http-on-freebsd-12-0-es){target='_blanck'} Adapta el contenido a tu sistema operativo.

🔗 **Referencias:**  

- [Pautas de seguridad de Mozilla](https://infosec.mozilla.org/guidelines/web_security){target='_blank'}
- [OWASP. Secure Headers Project](https://owasp.org/www-project-secure-headers/){target='_blank'}

---

## 3️⃣ Operaciones y despliegue

### 3.1. Proxy inverso

El [**proxy inverso**](https://www.cloudflare.com/es-es/learning/cdn/glossary/reverse-proxy/){target='_blank'} actúa como intermediario entre los clientes y uno o varios servidores backend.
Permite distribuir tráfico, ocultar la infraestructura interna y centralizar el acceso seguro.

**Ejemplo simplificado:**

```nginx
server {
  listen 443 ssl;
  server_name gestortareas.local;

  location / {
    proxy_pass http://127.0.0.1:3001;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $remote_addr;
  }
}
```
↗️ [Actividad externa](https://www.digitalocean.com/community/tutorials/nginx-reverse-proxy-node-angular){target='_blank'}

---

### 3.2. Balanceo de carga

El [**balanceo de carga**](https://www.digitalocean.com/community/tutorials/what-is-load-balancing){target='_blank'} reparte las peticiones entre varios servidores backend.
NGINX puede hacerlo de forma nativa:

**Ejemplo parcial:**

```nginx
upstream app_tareas {
  server 127.0.0.1:3001;
  server 127.0.0.1:3002;
}

server {
  listen 443 ssl;
  server_name gestortareas.local;

  location / {
    proxy_pass http://app_tareas;
  }
}
```
↗️ [Actividad externa](https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-load-balancing){target='_blank'}

🔎 **Comprobación:**
Lanza varias peticiones seguidas con `curl` y observa si alterna las respuestas entre los backends.

🔗 **Referencias:**  

  - [NGINX Load Balancing](https://nginx.org/en/docs/http/load_balancing.html){target='_blank'}

---

### 3.3. Automatización y despliegue reproducible
Un despliegue reproducible significa que cada vez que despliegues tu aplicación web, obtendrás exactamente el mismo resultado independientemente de:  

  ✅ Cuándo lo hagas (hoy, mañana, en 6 meses)  
  ✅ Dónde lo hagas (localhost, staging, producción)  
  ✅ Quién lo haga (tú, otro developer, CI/CD)  

En entornos reales, los servidores web suelen desplegarse con **contenedores Docker**, **Ansible** o en instancias cloud (**AWS EC2**, **Azure**, etc.).
Por ejemplo, el archivo `Dockerfile` de un servicio web simple con NGINX podría ser:

```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
```

Ejemplo real con GitHub Actions:

```yml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main]

jobs:
  # FASE CI - INTEGRACIÓN CONTINUA
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout código
        uses: actions/checkout@v3
      
      - name: Instalar Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Instalar dependencias
        run: npm ci
      
      - name: Ejecutar tests
        run: npm test
      
      - name: Build de la aplicación
        run: npm run build
  
  # FASE CD - DESPLIEGUE CONTINUO
  deploy-staging:
    needs: build-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Desplegar a staging
        run: |
          echo "Desplegando versión ${{ github.sha }} a staging..."
          # Comandos reales de despliegue aquí
  
  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Aprobar despliegue a producción
        # Espera aprobación manual
      
      - name: Desplegar a producción
        run: |
          echo "Desplegando a producción!"
```
---

## 4️⃣ Monitorización y análisis

### 4.1. Monitorización de estado

La monitorización continua del servidor web es esencial para garantizar la disponibilidad y rendimiento óptimo del servicio. Esta práctica permite detectar proactivamente incidencias como caídas del servicio, picos de tráfico inusuales o intentos de acceso no autorizados. Mediante herramientas de monitorización como Nagios, Zabbix o Prometheus, se pueden establecer alertas automáticas que notifiquen sobre métricas críticas como el uso de CPU y memoria, el número de conexiones simultáneas, los tiempos de respuesta y los códigos de estado HTTP. Además, el análisis de logs en tiempo real con utilidades como GoAccess o Logwatch proporciona insights valiosos sobre patrones de tráfico, intentos de ataques y errores de aplicación, permitiendo una respuesta rápida ante posibles amenazas y optimizando la experiencia del usuario final.

NGINX dispone del módulo **stub_status**, que permite consultar en tiempo real: Conexiones activas, peticiones procesadas, trafico total.

**Ejemplo (no completo):**

```nginx
location /nginx_status {
  stub_status;
  allow 127.0.0.1;
  deny all;
}
```
### 4.2. Logs y métricas

Los logs y métricas del servidor web constituyen una fuente invaluable de información para el diagnóstico y optimización del servicio. Los archivos de log, como access.log y error.log, registran cada solicitud HTTP, capturando detalles esenciales como direcciones IP de clientes, métodos HTTP utilizados, códigos de estado de respuesta, recursos solicitados y user agents. Complementariamente, las métricas en tiempo real proporcionan una visión inmediata del estado del sistema, monitoreando indicadores clave como el número de conexiones activas, el uso de memoria y CPU, el throughput de red y los tiempos de respuesta promedio. Herramientas especializadas como GoAccess para análisis de logs en tiempo visual, Prometheus coupled con Grafana para dashboards de métricas, y el ELK Stack (Elasticsearch, Logstash, Kibana) para análisis avanzado, permiten correlacionar esta información para identificar patrones de tráfico anómalos, detectar intentos de intrusión, optimizar el rendimiento y planificar la capacidad futura del servidor de manera proactiva.

Ejemplo de línea de log de acceso (NGINX):

```
192.168.0.15 - - [28/Oct/2025:10:24:12 +0100] "GET /index.html HTTP/1.1" 200 514 "-" "Mozilla/5.0"
```

**Significado:**

* IP del cliente
* Fecha y hora
* Método y recurso solicitado
* Código de respuesta HTTP
* Tamaño de la respuesta

Puedes utilizar comandos de linux como grep o herramientas específicas para el manejo de logs.

```bash
grep "404" /var/log/nginx/access.log
```

🛠️ Herramientas útiles:  
    
  - Análisis visual de logs: [`goaccess`](https://goaccess.io/){target='_blank'}
  - Bloqueo de IPs: [`fail2ban`](https://github.com/fail2ban/fail2ban){target='_blank'} 
  - Comandos linux para rendimiento y conexiones: `htop`, `ss`, `iftop`   

🔗 **Referencias:**  

- [Apache Logging Guide](https://httpd.apache.org/docs/current/logs.html){target='_blank'}
- [NGINX Logging Module](https://nginx.org/en/docs/http/ngx_http_log_module.html){target='_blank'}

---

🔗 **Referencias:**  

- [NGINX stub_status Documentation](https://nginx.org/en/docs/http/ngx_http_stub_status_module.html)

---

## 5️⃣ Documentación y buenas prácticas

### 5.1. Elaboración de documentación técnica

La elaboración de documentación técnica constituye un pilar fundamental en la administración profesional de servidores web, ya que no solo facilita el mantenimiento y la escalabilidad del sistema, sino que también garantiza la continuidad operativa ante eventuales cambios de personal o situaciones de crisis. Una documentación efectiva debe incluir aspectos como la arquitectura detallada del servicio, configuraciones específicas implementadas, procedimientos de respaldo y recuperación, políticas de seguridad aplicadas, y protocolos de escalado ante incrementos de carga. Mediante herramientas como Markdown para redacción técnica, diagrams.net para esquemas arquitectónicos, y Git para control de versiones de la documentación, se puede construir un repositorio de conocimiento accesible y actualizado que sirva tanto para la formación de nuevos administradores como para la resolución ágil de incidencias, transformando el conocimiento tácito en explícito y asegurando la sostenibilidad a largo plazo de la infraestructura web desplegada.


### 5.2. Buenas prácticas recomendadas
La elaboración de documentación técnica efectiva requiere seguir metodologías estructuradas que garanticen claridad, consistencia y utilidad práctica. Entre las buenas prácticas fundamentales se incluye:  

✅ *Estructura y formato*

* Formato estandarizado - Mantener consistencia en toda la documentación
* Lenguaje claro y conciso - Evitar tecnicismos innecesarios pero mantener rigor técnico
* Organización modular - Dividir contenido en secciones lógicas y específicas

✅ Contenido Técnico

* Diagramas y visuales - Incluir esquemas arquitectónicos y flujos de procesos
* Ejemplos prácticos - Incorporar casos de uso reales y configuraciones demostrativas
* Procedimientos paso a paso - Documentar procesos operativos de forma secuencial

✅ Mantenimiento y Control

* Control de versiones - Implementar sistema de seguimiento de cambios históricos
* Revisiones periódicas - Establecer ciclos de actualización y verificación
* Accesibilidad - Garantizar que la documentación sea fácil de encontrar y consultar


✅ Herramientas Recomendadas

* Markdown para redacción técnica
* Git para control de versiones
* diagrams.net para creación de diagramas
* Repositorios centralizados para almacenamiento accesible

🔗 **Referencias:**

* [Technical Writing](https://developers.google.com/tech-writing){target=_blank}

---

## ✨ Conclusión

La correcta administración de servidores web es una de las competencias más valiosas en el despliegue profesional de aplicaciones.
Dominar herramientas como Apache y NGINX permite implantar sistemas escalables, seguros y mantenibles.

Estas prácticas te ayudarán a **aplicar progresivamente** todo lo aprendido: desde un simple sitio web hasta un despliegue seguro con proxy inverso, balanceo y control de acceso.

---
