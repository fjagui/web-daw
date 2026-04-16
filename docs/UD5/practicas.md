## Práctica 1: Despliegue de Arquitectura Distribuida y Transferencia Segura

### 1. Contexto del Proyecto
El objetivo es migrar una aplicación MVC en PHP (`contactos.local`) desde un entorno de desarrollo puramente local a una infraestructura de red profesional distribuida. En este escenario, la infraestructura (DNS y Servidor Web) está separada del entorno de desarrollo (tu PC), obligando a utilizar protocolos de transferencia segura para el despliegue, tal como se realiza en entornos de producción reales.

### 2. Requisitos de la Infraestructura
Deberás configurar un ecosistema compuesto por **dos máquinas virtuales** (Debian) y tu **máquina anfitriona**:

* **Nodo A (Servidor DNS):** Gestión de la resolución de nombres mediante **BIND9**.
* **Nodo B (Servidor Web):** Servidor de aplicaciones basado en **Nginx** y **PHP-FPM**.
* **Nodo C (Cliente/Desarrollador):** Tu máquina real donde desarrollarás el código y realizarás el despliegue.

### 3. Objetivos.

#### Fase I: Gestión de Documentación y Plantillas
* **Mapa de Red:** Generar un documento (PDF o Markdown) que identifique las IPs estáticas, interfaces y roles de cada nodo.
* **Plantilla DNS:** Crear una **plantilla maestra** para el archivo de zona DNS que facilite la escalabilidad (ej. añadir `api.contactos.local` en el futuro).

#### Fase II: Configuración de Infraestructura
* **DNS:** Configurar en el Nodo A las zonas de resolución directa e inversa para `contactos.local`, apuntando los registros **A** hacia la IP del Nodo B.
* **Nginx:** Configurar un *Server Block* en el Nodo B que responda a `contactos.local`.
* **Validación:** Eliminar las entradas en el fichero `hosts` del Nodo C y configurar su DNS para que apunte al Nodo A. La resolución debe ser real, no local.

#### Fase III: Despliegue Profesional y Seguridad
* **Protocolo Seguro:** Queda prohibida la edición de código directamente en la VM. Se debe desarrollar en el Nodo C y desplegar en el Nodo B utilizando **SFTP** o **SCP** (puerto 22).
* **Fortalecimiento (Hardening):** Configurar el acceso SSH en el Nodo B mediante **llaves RSA/ED25519**, desactivando el acceso por contraseña para el despliegue.
* **Control de Versiones:** Inicializar repositorios **Git** independientes para la configuración del servidor (`/etc/bind`, `/etc/nginx`) y para el código de la aplicación en el Nodo C.

#### Fase IV: Verificación
* **Diagnóstico:** Realizar pruebas con `dig` o `nslookup`
* **Auditoría de Despliegue:** Verificar que los archivos transferidos mantienen los permisos correctos (644 para archivos / 755 para directorios) y pertenecen al usuario de servicio `www-data`.
* **Acceso Web:** Comprobar la carga de la aplicación MVC desde el navegador del Nodo C.

### 4. Entregables
*  **Enlace al repositorio/s** con el histórico de commits (debe reflejar la evolución de la configuración y el código).
*  **Documento de Despliegue:**
    * Diagrama de red.
    * Capturas de la configuración de seguridad SSH (llaves).
    * Resultados de las pruebas de resolución y métricas de carga.

## Práctica 2: Autenticación Centralizada y Seguridad de Servicios

### 1. Contexto del Proyecto

En esta fase se amplía la infraestructura distribuida creada en la Práctica 1, incorporando un sistema de autenticación centralizado basado en directorio LDAP. El objetivo es desacoplar la gestión de usuarios de la aplicación web, simulando un entorno corporativo real donde la autenticación se externaliza a un servicio especializado.

Se mantiene la arquitectura existente y se añade un nuevo nodo dedicado a servicios de identidad.

### 2. Requisitos de la Infraestructura

El ecosistema estará compuesto por tres nodos:

* **Nodo A (Servidor DNS):** BIND9 para resolución de nombres.
* **Nodo B (Servidor Web):** Nginx + PHP-FPM con la aplicación MVC.
* **Nodo C (Servidor LDAP):** OpenLDAP para autenticación centralizada.

### 3. Objetivos

#### Fase I: Despliegue del Servicio de Directorio (LDAP)

* Instalación de `slapd` y `ldap-utils` en el Nodo C.
* Creación de la estructura organizativa:

  * `ou=usuarios,dc=contactos,dc=local`
* Definición de plantillas `.ldif` para la creación de al menos tres usuarios con credenciales diferenciadas.

#### Fase II: Integración con la Infraestructura

**DNS (Nodo A):**

* Crear el registro `ldap.local` apuntando a la IP del Nodo C.

**Servidor Web (Nodo B):**

* Instalar soporte LDAP en PHP:

  * `php-ldap`
* Reiniciar servicios de Nginx y PHP-FPM tras la instalación.

**Control de Versiones:**

* Registrar en Git los cambios realizados en cada nodo (configuración y módulos instalados).

#### Fase III: Integración de la Aplicación

* Modificar el sistema de autenticación de la aplicación PHP para que utilice `ldap_bind` contra `ldap.local`.
* Eliminar cualquier validación basada en bases de datos locales o estructuras estáticas.

**Seguridad:**

* Las credenciales del administrador LDAP **no deben almacenarse en el repositorio Git**. y deben gestionarse mediante:  
  
    * variables de entorno.
    * archivos excluidos mediante `.gitignore`.

### 4. Verificación

* Pruebas de conectividad con `ldapsearch` desde el Nodo B al Nodo C.
* Validación de tráfico en el puerto 389.
* Revisión de logs en `/var/log/syslog` o logs de `slapd`:

    * intentos de autenticación exitosos
    * intentos fallidos

* Informe breve de incidencias y resolución de problemas de dependencias PHP-LDAP.

### 5. Entregables

* Repositorio Git con el historial de cambios.
* Evidencias de configuración del sistema LDAP.
* Capturas de logs de autenticación.
* Documento técnico con incidencias y resolución.
* Prueba funcional de autenticación desde la aplicación web.

## Práctica 3: Contenedorización y Orquestación del Ecosistema “Contactos”

### 1. Contexto del Proyecto

Tras validar la arquitectura distribuida, se evoluciona hacia un modelo basado en contenedores. El objetivo es encapsular cada servicio del sistema en unidades independientes y portables, facilitando su despliegue, escalabilidad y mantenimiento mediante Docker.

### 2. Objetivos de la Tarea

#### Fase I: Creación de Imágenes Docker

* Desarrollo de un `Dockerfile` para Nginx con configuración de `contacts.local`.
* Creación de una imagen para PHP-FPM con extensiones:

  * `mysqli`
  * `ldap`
* Configuración de volúmenes para separar código y entorno de ejecución.

#### Fase II: Orquestación con Docker Compose

Creación de un archivo `docker-compose.yml` que incluya:

* Servicio web (Nginx)
* Servicio de aplicación (PHP-FPM)
* Servicio de directorio (LDAP con imagen oficial)

**Red interna:**

* Comunicación entre servicios mediante nombres de contenedor (DNS interno de Docker).
* Eliminación de dependencias de DNS externo.

#### Fase III: Seguridad y Configuración

* Uso de archivo `.env` para variables sensibles (contraseñas, DN, etc.).
* Exclusión obligatoria del `.env` en Git mediante `.gitignore`.

#### Fase IV: Validación

* Configuración de **healthchecks** para verificar disponibilidad de servicios.
* Documentación del procedimiento completo de despliegue:
* “Cómo levantar el entorno desde cero en un nuevo sistema”.

### 4. Entregables

* Repositorio Git con:

    * Dockerfiles
    * docker-compose.yml
    * historial de commits
  
* Evidencia de ejecución:

    * `docker ps` mostrando servicios activos
    * acceso funcional a la aplicación desde navegador

## Práctica 4: Despliegue en la Nube y Escalabilidad con AWS

### 1. Contexto del Proyecto

La aplicación ha alcanzado un nivel de madurez que requiere una infraestructura escalable, altamente disponible y gestionada en la nube. Se migra el sistema a Amazon Web Services (AWS), sustituyendo la infraestructura manual por servicios cloud administrados.

### 2. Servicios de AWS Utilizados

* **EC2:** Servidor web Nginx + PHP
* **RDS:** Base de datos gestionada
* **Route 53:** Gestión DNS
* **VPC:** Red privada virtual
* **IAM:** Gestión de permisos y seguridad

### 3. Objetivos

#### Fase I: Arquitectura de Red y DNS

* Creación de una VPC con subredes públicas y privadas.
* Configuración de Route 53 para resolución del dominio hacia la IP elástica.
* Elaboración de un diagrama de arquitectura cloud.


#### Fase II: Despliegue Automatizado en EC2

* Lanzamiento de instancia EC2 (Ubuntu o Amazon Linux).
* Uso de scripts **User Data** para instalación automática de:

    * Nginx
    * PHP
    * dependencias LDAP / base de datos

#### Fase III: Seguridad y Gestión de Secretos

* Configuración de Security Groups:

    * HTTP (80)
    * SSH (22) restringido por IP
* Uso de AWS Systems Manager Parameter Store para credenciales.
* Eliminación de secretos del repositorio Git.

#### Fase IV: Monitorización y Calidad

* Configuración de CloudWatch para métricas:

    * CPU
    * memoria
    * estado de instancias
  
* Pruebas de carga para evaluar escalabilidad.

### 4. Objetivo Final

Demostrar que la aplicación es accesible públicamente desde AWS y que mantiene autenticación LDAP funcional en un entorno cloud real.


### 5. Entregables

* URL pública de la aplicación desplegada.
* Repositorio Git con scripts de automatización.
* Informe de monitorización (CloudWatch).
* Diagrama de arquitectura cloud.
