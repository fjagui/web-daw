# Implantación de arquitecturas web.
## 1. Arquitecturas web
### 1.1. Introducción.
La arquitectura web es el esquema estructural y lógico que define cómo interactúan los diferentes componentes de una aplicación web (frontend, backend, bases de datos, servidores, etc.) para procesar una petición de usuario y entregar una respuesta.

La elección de una arquitectura adecuada es fundamental, ya que determina aspectos críticos del proyecto:

- **Escalabilidad:** Capacidad para crecer y manejar aumentos de carga
- **Mantenibilidad:** Facilidad para corregir errores y añadir nuevas funcionalidades
- **Rendimiento:** Velocidad y eficiencia en la respuesta
- **Fiabilidad y Disponibilidad:** Tolerancia a fallos y tiempo de actividad
- **Seguridad:** Protección de los datos y la infraestructura

A lo largo del tiempo, las arquitecturas han evolucionado desde modelos monolíticos simples hasta sistemas distribuidos y desacoplados complejos, impulsados por la necesidad de satisfacer demandas modernas.

### 1.2. Modelos de arquitecturas web.
#### a) Arquitectura monolítica.
Es el modelo tradicional donde todos los componentes de la aplicación (interfaz de usuario, lógica de negocio, capa de acceso a datos) están acoplados en un único programa o proyecto y se despliegan como una sola unidad.

**Características:**   

- Código único y base de código unificada.  
- Desarrollo, testing y despliegue  implificados al principio.   
- Comunicación entre componentes mediante llamadas a funciones o métodos internos (muy rápida).  
- Generalmente, una única base de datos.  

**Ventajas:**  

- **Simplicidad inicial:** Fácil de desarrollar, probar y desplegar.  
- **Desarrollo ágil:** Ideal para proyectos pequeños o MVPs (Producto Mínimo Viable).
- **Comunicación eficiente:** Al estar todo en el mismo proceso, la comunicación es directa y rápida.  

**Inconvenientes:**  

- **Acoplamiento fuerte:** Un cambio pequeño puede requerir redeploy de toda la aplicación.  
- **Escalabilidad limitada:** Para escalar, se debe duplicar la aplicación completa.  
- **Barrera tecnológica:** Dificulta la adopción de nuevas tecnologías o frameworks.  
- **Baja fiabilidad:** Un fallo en un módulo pequeño puede afectar a toda la aplicación.  

**Caso de uso ideal:** Aplicaciones pequeñas, con poca carga, equipos de desarrollo reducidos y tiempo de salida al mercado crítico.  

#### b) Arquitectura de 2 Capas (Cliente-Servidor).

Es el modelo clásico donde las responsabilidades se separan en dos partes claramente diferenciadas:

1. **Cliente ("Frontend"):** Solicita y presenta la información al usuario.
2. **Servidor ("Backend"):** Procesa las peticiones, ejecuta la lógica de negocio y gestiona el acceso a los datos.  

**Características:**  

- Separación clara de responsabilidades.  
- El servidor suele albergar tanto la lógica de negocio como la base de datos.  

**Ventajas:**  

- **Mejor organización** que una arquitectura monolítica pura.  
- **Centralización:** La gestión y la seguridad son más fáciles de aplicar en el servidor.  

**Inconvenientes:** 

- El servidor puede convertirse en un cuello de botella.  
- La escalabilidad sigue siendo un desafío.  

#### c) Arquitectura de 3 Capas / N-Capas

Este modelo divide la aplicación en tres capas lógicas y físicas independientes:

1. **Capa de Presentación (Frontend):** Interfaz de usuario que interactúa con el cliente.  
2. **Capa de Lógica de Negocio (Backend/Aplicación):** Contiene las reglas y procesos del negocio.  
3. **Capa de Datos (Base de Datos):** Almacena, recupera y gestiona la información.  

**Características:**  

- Desacoplamiento total entre la presentación, la lógica y los datos.    
- Cada capa puede ser desarrollada, escalada y actualizada de forma independiente.  

**Ventajas:** 

- **Alta escalabilidad:** Cada capa puede escalarse por separado.  
- **Mantenibilidad:** Los cambios en una capa no afectan a las otras.  
- **Mayor seguridad:** Es más fácil aplicar políticas de seguridad entre capas.  
- **Flexibilidad tecnológica:** Se pueden usar diferentes tecnologías en cada capa.  

**Inconvenientes:**  
  
- **Complejidad aumentada:** Mayor sobrecarga de trabajo en el desarrollo, configuración y despliegue.  
- **Latencia:** La comunicación entre capas introduce latencia.

**Caso de uso ideal:** Aplicaciones empresariales medianas y grandes.

#### d) Arquitectura Microservicios

Evolución natural de la arquitectura de N-Capas, donde una aplicación se compone de un conjunto de servicios pequeños, independientes y altamente desacoplados.

**Características:**  

- **Servicios independientes:** Cada microservicio tiene control de sus datos.  
- **Fuerte desacoplamiento:** Fallos en un servicio no afectan a los demás.  
- **Gobernanza descentralizada:** Cada equipo puede elegir la tecnología más adecuada para su desarrollo.  
- **Comunicación via API:** HTTP/REST, mensajes asíncronos.   

**Ventajas:**  

- **Escalabilidad granular:** Se escala solo el servicio que lo necesita. 
- **Alta disponibilidad:** Un fallo está aislado en un servicio.   
- **Libertad tecnológica:** Elección de mejores herramientas para cada problema.  
- **Despliegues independientes:** Se puede desplegar un servicio sin afectar al resto.  

**Inconvenientes:**  

- **Alta complejidad operativa:** Requiere orquestación de contenedores y monitorización.  
- **Overhead en la comunicación:** La latencia de red añade complejidad.   
- **Consistencia de datos eventual:** Difícil mantener transacciones [ACID](https://es.wikipedia.org/wiki/ACID){target=blank} entre servicios. 


- **Mayor demanda de recursos:** Mayor consumo de memoria y CPU.  

**Caso de uso ideal:** Sistemas grandes y complejos con equipos numerosos.

#### e) Arquitectura Serverless (Sin Servidor)

Modelo donde el desarrollador no gestiona servidores. Se escribe código en forma de funciones que se ejecutan en respuesta a eventos.

**Características:**

- **Abstracción total del servidor:** No hay que aprovisionar o mantener servidores.
- **Ejecución dirigida por eventos:** El código se activa solo cuando es necesario.
- **Escalado automático y elástico:** De cero a miles de instancias de forma automática.
- **Pago por uso:** Solo se paga por el tiempo de computación consumido.

**Ventajas:**

- **Máxima escalabilidad:** Escalado automático e inherente.
- **Reducción de costes operativos:** No hay costes por servidor inactivo.
- **Enfoque en el código:** El equipo se centra únicamente en la lógica de negocio.
- **Alta disponibilidad:** Los proveedores la ofrecen por defecto.

**Inconvenientes:**  

- **Vendor lock-in:** Alta dependencia del proveedor cloud.
- **Cold starts:** La primera invocación puede tener latencia.
- **Depuración compleja:** Es más difícil debuggear funciones distribuidas.
- **Limitaciones de tiempo y recursos:** Tiempos de ejecución máximos

**Caso de uso ideal:** APIs backend, procesamiento de datos en tiempo real, tareas asíncronas.

No existe una arquitectura "mejor" universalmente. La elección depende de factores como la complejidad del proyecto, el tamaño del equipo, los requisitos de escalabilidad, el presupuesto y el tiempo de entrega.

- **Monolito:** Comienza simple. Válido para muchos proyectos
- **Microservicios:** Adóptalo cuando la complejidad del monolito sea insostenible
- **Serverless:** Ideal para [lógica event-driven](https://www.itmastersmag.com/innovacion-emprendimiento/que-es-la-arquitectura-event-driven-y-como-pueden-aprovecharla-las-organizaciones/){target=blank} y para descargar la gestión de infraestructura

La tendencia actual se dirige hacia arquitecturas híbridas que combinan lo mejor de cada modelo y hacia el uso de **contenedores** (Docker) y **orquestadores** (Kubernetes) como estándar para empaquetar, desplegar y gestionar aplicaciones modernas.

## 2. Servidores Web. Servidores de Aplicaciones

### 2.1. Introducción

En el contexto de despliegue de aplicaciones web, los **servidores** son componentes software esenciales que permiten que los usuarios accedan a los recursos y funcionalidades de una aplicación web.

Tradicionalmente se distinguen dos tipos principales:

- **Servidores Web**: gestionan peticiones HTTP/HTTPS y sirven principalmente contenido estático.  
- **Servidores de Aplicaciones**: ejecutan la lógica de negocio y generan contenido dinámico.  

En la década de 2000 era habitual hablar de *Application Servers* (ej.: JBoss, WebSphere, GlassFish, Tomcat en Java), que ofrecían en un solo paquete tanto el servidor web como los servicios de ejecución de la aplicación. Estos servidores eran pesados y monolíticos.  

Con el tiempo, el enfoque moderno evolucionó hacia una **separación de responsabilidades**, donde cada componente cumple un rol específico:  

- **Servidor web** (Nginx, Apache, Caddy): sirve archivos estáticos, balancea carga, maneja TLS.  
- **Servidor de aplicaciones ligero** (Gunicorn, Uvicorn, PHP-FPM, RoadRunner): se encarga de ejecutar el código de la aplicación.  
- **Servicios externos especializados**: bases de datos, colas de mensajería (RabbitMQ, Kafka), sistemas de caché (Redis), etc.  

Esto hace que el término "servidor de aplicaciones" en su sentido clásico haya perdido protagonismo. Hoy se habla más de *application runtimes* o servidores ligeros embebidos.  

En **Java**, todavía existen servidores tradicionales (WildFly, WebLogic), aunque muchas aplicaciones migraron a marcos como Spring Boot, que incluyen servidores embebidos (Tomcat, Jetty).  

En **Python, PHP o Node.js**, el modelo predominante es un proceso de aplicación acompañado de un servidor web que actúa como proxy inverso.  

En resumen, los **servidores de aplicaciones no han desaparecido**, pero ya no se usan como piezas centralizadas y monolíticas, sino como parte de arquitecturas más distribuidas y flexibles.  

### 2.2 Servidores Web

#### a) Concepto y Funcionalidad

Un **servidor web** es un software diseñado para recibir peticiones de clientes (navegadores, dispositivos, servicios) a través de HTTP/HTTPS y devolver respuestas. Estas respuestas pueden incluir:  

- Archivos estáticos (HTML, CSS, JavaScript, imágenes).  
- Contenido dinámico generado en colaboración con un servidor de aplicaciones.  
- Reglas de redirección o reescritura de URL.  

Además, los servidores web suelen cumplir funciones de seguridad (TLS/SSL), balanceo de carga y proxy inverso.  

#### b) Principales Servidores Web

**Apache HTTP Server**  

- Software libre y de código abierto.  
- Sistema modular (mod_rewrite, mod_security, mod_ssl).  
- Amplia documentación y comunidad activa.  
- Configuración flexible mediante archivos `.htaccess`.  

**Nginx**   

- Alto rendimiento y bajo consumo de recursos.  
- Arquitectura orientada a eventos.  
- Ideal para servir contenido estático y actuar como proxy inverso.  
- Configuración centralizada y ligera.  

**Microsoft IIS**   

- Integrado en el ecosistema Microsoft.  
- Soporte nativo para aplicaciones ASP.NET.  
- Administración mediante interfaz gráfica y herramientas de Windows.  

### 2.3. Servidores de Aplicaciones

#### a) Concepto y Funcionalidad

Un **servidor de aplicaciones** es un componente software diseñado para ejecutar la lógica de negocio de una aplicación web, procesando peticiones dinámicas y conectando con servicios externos (bases de datos, colas de mensajes, APIs).  

A diferencia del servidor web, que se centra en entregar contenido, el servidor de aplicaciones:  

- Procesa reglas de negocio.  
- Ejecuta código en distintos lenguajes (Java, Python, PHP, Node.js, etc.).  
- Maneja conexiones con bases de datos y servicios externos.  
- Escala horizontalmente mediante múltiples instancias.  

#### b) Modelos de Servidores de Aplicaciones

**Tradicionales (monolíticos)**    

   Los **servidores de aplicaciones tradicionales o monolíticos** constituyen plataformas integrales diseñadas para ejecutar aplicaciones empresariales en un entorno centralizado. Se caracterizan por incluir en un mismo sistema un servidor web, un motor de ejecución, un sistema de mensajería y servicios avanzados de gestión de transacciones, lo que permitía a las organizaciones disponer de una infraestructura unificada y estandarizada. Este enfoque ofrecía ventajas significativas en términos de robustez, consistencia y soporte a arquitecturas distribuidas complejas, especialmente en los grandes sistemas corporativos de principios de los 2000. Sin embargo, también presentaba limitaciones relacionadas con la rigidez, el elevado consumo de recursos y la dificultad de escalar de forma granular. Entre los ejemplos más representativos de este modelo destacan **JBoss/WildFly, WebLogic, WebSphere y GlassFish**, ampliamente utilizados en el ecosistema Java empresarial de aquella época. No obstante, conviene señalar que algunos de estos productos, en particular **Oracle WebLogic**, siguen siendo mantenidos y evolucionados, incorporando compatibilidad con **Jakarta EE**, soporte para **contenedores y Kubernetes** y despliegue en la nube, lo que garantiza su continuidad y relevancia en determinados entornos corporativos.

**Ligeros o embebidos**   

Los **servidores de aplicaciones ligeros o embebidos** representan un modelo más moderno y flexible que contrasta con los tradicionales monolíticos. En este enfoque, el propio **runtime o framework** incluye un servidor HTTP integrado, eliminando la necesidad de un contenedor de aplicaciones pesado. Este modelo permite desplegar aplicaciones como procesos autónomos, que pueden ejecutarse en entornos de microservicios, contenedores o directamente en la nube, con mayor agilidad y menor consumo de recursos. Entre sus principales ventajas se encuentran la **simplicidad de configuración**, la **rapidez en el arranque**, la **adaptación natural a arquitecturas distribuidas** y la **facilidad de escalado horizontal**. Ejemplos habituales son **Node.js**, que incorpora su propio servidor HTTP nativo, **Go** con el paquete estándar `net/http`, o entornos como **Spring Boot** en Java y **Uvicorn** o **Gunicorn** en Python, que proporcionan servidores embebidos compatibles con WSGI/ASGI. Gracias a estas características, los servidores embebidos se han consolidado como la base tecnológica de gran parte de las aplicaciones y plataformas modernas en la nube.

---

| Característica                  | Tradicionales / Monolíticos                           | Ligeros / Embebidos (Modernos)                  |
|---------------------------------|-------------------------------------------------------|------------------------------------------------|
| **Modelo de ejecución**         | Entorno integral que combina servidor web, motor de ejecución, mensajería y gestión de transacciones en un mismo sistema | El runtime o framework incluye un servidor HTTP embebido, ejecutándose como proceso autónomo |
| **Ejemplos**                    | JBoss/WildFly, WebLogic, WebSphere, GlassFish         | Node.js, Go (`net/http`), Spring Boot, Uvicorn, Gunicorn |
| **Ventajas**                    | Robustez, consistencia, soporte avanzado para arquitecturas distribuidas complejas | Ligereza, simplicidad, rapidez en el arranque, adaptación natural a microservicios y contenedores |
| **Limitaciones**                | Rigidez, consumo elevado de recursos, dificultad de escalado granular | Menor cobertura de servicios integrados (mensajería, transacciones complejas), más dependencia de librerías externas |
| **Situación actual**            | Algunos siguen vigentes (ej. Oracle WebLogic con soporte para Jakarta EE, contenedores y Kubernetes) | Constituyen la base tecnológica de gran parte de las aplicaciones modernas en la nube |
| **Escalabilidad**               | Vertical (requiere más hardware y configuración compleja) | Horizontal (escalar procesos ligeros de forma sencilla en contenedores o clusters) |

#### c) Tendencias Actuales
En la actualidad, los servidores de aplicaciones tienden a ser más ligeros y modulares, adaptándose a entornos basados en **contenedores** (Docker, Kubernetes) que permiten desplegar aplicaciones de manera aislada y escalable. Asimismo, se populariza el uso de **runtimes especializados** en lenguajes modernos (como Deno o Bun) que optimizan el rendimiento y la simplicidad del desarrollo. Finalmente, las arquitecturas orientadas a **microservicios** y modelos **serverless** están transformando el panorama, al distribuir la lógica de negocio en múltiples servicios pequeños o incluso en funciones sin servidor (AWS Lambda, Azure Functions), lo que aporta mayor flexibilidad y eficiencia en la gestión de aplicaciones.


### 2.4. Comparativa entre Servidores Web y Servidores de Aplicaciones

| Característica                | Servidores Web                              | Servidores de Aplicaciones                          |
|-------------------------------|---------------------------------------------|----------------------------------------------------|
| **Función principal**         | Entregar contenido estático y gestionar HTTP/HTTPS | Ejecutar lógica de negocio y generar contenido dinámico |
| **Ejemplos**                  | Apache, Nginx, IIS                          | WildFly, WebLogic, Tomcat, Gunicorn, Uvicorn       |
| **Contenido servido**         | HTML, CSS, JS, imágenes                     | Respuestas dinámicas basadas en reglas de negocio  |
| **Complejidad**               | Relativamente simples                       | Más complejos, requieren integración con servicios externos |
| **Modelo clásico**            | Proxy inverso + archivos estáticos          | Monolítico (todo en un solo paquete)               |
| **Modelo moderno**            | Proxy inverso + balanceo de carga           | Ligeros/embebidos + microservicios                 |
| **Escalabilidad**             | Muy eficiente en concurrencia               | Escala mediante instancias adicionales             |
| **Ejemplo de uso típico**     | Servir la web de un periódico               | Gestionar la lógica de un sistema bancario o de reservas |


## 3. Virtualización.
### 3.1. Introducción.
La virtualización es una tecnología que permite crear versiones virtuales de recursos físicos de computación, como servidores, almacenamiento, redes y dispositivos. Esta capa de abstracción posibilita:  

- Ejecutar múltiples sistemas operativos simultáneamente en un mismo hardware físico.  
- Aislar entornos de ejecución entre diferentes aplicaciones.  
- Optimizar la utilización de recursos hardware.  
- Facilitar la portabilidad y migración de cargas de trabajo.  

### 3.2. Virtualización Tradicional (Hypervisores)
#### Componentes.
- Hypervisor (VMM - Virtual Machine Monitor): Software que crea y ejecuta máquinas virtuales.  
- Máquina Virtual (VM): Entorno aislado que emula un sistema físico completo.  
- Host: Máquina física que aloja el hypervisor y las VMs.  
- Guest: Sistema operativo invitado que se ejecuta dentro de una VM.  
- Recursos Virtualizados: CPU, memoria, almacenamiento y red asignados a las VMs.  

#### Tipos de Virtualización de Servidores.

- **Virtualización Completa (Type 1 - Bare Metal)**:
    - Hypervisor instalado directamente sobre el hardware físico.
    - Ejemplos: VMware ESXi, Microsoft Hyper-V, Xen, KVM.
    - Mayor rendimiento y eficiencia. Ideal para entornos productivos y empresariales.

- **Virtualización Hospedada (Type 2 - Hosted)**:
    - Hypervisor ejecutado sobre un sistema operativo host.
    - Ejemplos: VMware Workstation, Oracle VirtualBox, Parallels.
    - Mayor facilidad de uso y configuración. Adecuado para desarrollo, testing y entornos desktop.

- **Otras Formas de Virtualización:**
    - Virtualización de Red: VLANs, redes definidas por software (SDN).
    - Virtualización de Almacenamiento: SAN virtual, almacenamiento definido por software.  
    - Virtualización de Escritorios: VDI (Virtual Desktop Infrastructure).

#### Principales Tecnologías de Hypervisor.
- **VMware vSphere/ESXi:**
    - Hypervisor tipo 1 de alto rendimiento. Suite completa de gestión (vCenter).
    - Ventajas: Estabilidad empresarial, herramientas avanzadas, excelente soporte.
- **Microsoft Hyper-V:**
    - Hypervisor tipo 1 integrado en Windows Server.
    - Ventajas: Coste cero para entornos Windows, integración con Active Directory.
- **KVM (Kernel-based Virtual Machine):**
    - Hypervisor tipo 1 integrado en el kernel Linux. Open-source y gratuito.
    - Ventajas: Coste cero, alto rendimiento, flexibilidad total.

#### Comparativa de Hypervisores

| Característica       | VMware ESXi         | Hyper-V                  | KVM                     |
|----------------------|---------------------|--------------------------|-------------------------|
| **Tipo**             | Type 1              | Type 1                   | Type 1                  |
| **Coste licencia**   | Alto                | Medio (gratis con WS)    | Gratuito                |
| **Rendimiento**      | Excelente           | Muy bueno                | Excelente               |
| **Facilidad uso**    | Alta                | Media-Alta               | Media                   |
| **Soporte empresarial** | Excelente        | Muy bueno                | Bueno (comercial)       |

#### Virtualización en la Nube
- **Modelos de Servicio Cloud:**
    - **IaaS** (Infrastructure as a Service): Infraestructura virtualizada completa (Ej: AWS EC2, Azure VMs).
    - **PaaS** (Platform as a Service): Plataforma de ejecución para aplicaciones (Ej: Heroku, Google App Engine).
    - **SaaS** (Software as a Service): Aplicaciones completas en la nube (Ej: Office 365, Gmail).
    - Principales **Proveedores Cloud**: Amazon Web Services (AWS), Microsoft Azure, Google Cloud Platform (GCP).

- **Ventajas:**
    - Optimización de recursos.
    - Flexibilidad.
    - Alta disponibilidad.
    - Aislamiento.
    - Ahorro de costes.
- **Inconvenientes:**
    - Complejidad.
    - Overhead de rendimiento.
    - Coste de licencias.
    - Dependencia del vendor o vendor lock-in. Es una situación en la que un cliente se ve atado a un proveedor de productos o servicios, haciendo que sea difícil o costoso cambiar a otro, debido a la tecnología propietaria, los altos costes de migración, o la integración profunda con un único proveedor.

- **Casos de Uso:**
    - Consolidación de servidores.  
    - Entornos de desarrollo y testing.  
    - Laboratorios educativos.  
    - Alta disponibilidad.  

### 3.3. Virtualización por Contenedores
Tecnología de virtualización a nivel de sistema operativo que permite ejecutar múltiples instancias aisladas de aplicaciones compartiendo el kernel del host.  

Las diferencias fundamentales con las VMs son:  

- Nivel de abstractación: Sistema operativo (no hardware).
- Menor tamaño.
- Tiempo de inicio inferior.
- Overhead bajo. Los proyectos tienen costos operativos indirectos y generales mínimos o reducidos.
 
#### Plataformas de Virtualización

- Soluciones especializadas en contenedores:
    - **Docker**: Estándar del mercado, mayor ecosistema.
    - **Containerd**: Runtime de bajo nivel para Kubernetes.  
    - **Podman**: Alternativa sin daemon, mayor seguridad.

- Plataformas Híbridas (Contenedores + VMs)
    - **Proxmox VE**: Plataforma de virtualización integral
        - Soporte nativo para contenedores LXC y máquinas virtuales.
        - Gestión unificada mediante interfaz web integrada
        - Ideal para entornos híbridos, infraestructuras on-premise (Departamento de Informática),laboratorios y entornos de testing,...
    

#### Arquitectura Básica
- Componentes Clave:
    - **Container Engine**: Gestiona ciclo de vida del contenedor (Docker, Containerd).
    - **Imágenes**: Plantillas read-only con aplicación y dependencias.
    - **Registry**: Repositorio de imágenes (Docker Hub, registros privados).
    - **Orquestador**: Gestión múltiple (Kubernetes, Docker Swarm).

#### Orquestación
La orquestación es la automatización de las operaciones de despliegue, gestión, escalado y networking de contenedores. Es el proceso que permite administrar múltiples contenedores que trabajan juntos como una aplicación completa.  

- **Kubernetes (K8s)**
    - Estándar de facto para producción
    - Arquitectura: Control Plane + Nodes
    - Conceptos: Pods, Services, Deployments

- **Docker Swarm**
    - Orquestación nativa de Docker
    - Más simple que Kubernetes
    - Adecuado para pequeños entornos

#### Casos de Uso por Plataforma
- **Docker/Podman**  
    - Desarrollo local y aplicaciones simples
    - Microservicios
    - CI/CD pipelines

- **Kubernetes**
    - Producción enterprise.
    - Aplicaciones distribuidas.
    - Escalabilidad automática.

- **Proxmox VE**
    - Infraestructuras híbridas.
    - Entornos de laboratorio.
    - Host para clusters Kubernetes.
---
La virtualización, tanto tradicional como por contenedores, es la base fundamental de la computación moderna y en la nube.  
la virtualización tradicional (Hypervisores) proporciona aislamiento completo y es ideal para ejecutar sistemas operativos heterogéneos y cargas de trabajo legacy, optimizando radicalmente el uso del hardware físico.  
La virtualización por contenedores ofrece una mayor eficiencia, portabilidad y velocidad para aplicaciones modernas, basadas en microservicios y prácticas DevOps.

La elección entre una u otra, o una combinación de ambas (entornos híbridos), depende de los requisitos técnicos específicos, el presupuesto, las habilidades del equipo y la estrategia tecnológica a largo plazo. El futuro continúa hacia una mayor abstractación, automatización y eficiencia en la gestión de recursos.


## 4. Documentación
### 4.1. Introducción.

La documentación es un componente crítico en el despliegue y mantenimiento de aplicaciones web, ya que:

- **Facilita la reproducibilidad** de los procesos de instalación y configuración.
- **Permite el onboarding** de nuevos miembros del equipo
- **Sirve como referencia** para troubleshooting y auditorías.
- **Asegura la consistencia** entre entornos (desarrollo, staging, producción).
- **Documenta decisiones técnicas** y justificaciones de configuración.

### 4.2. Tipos de Documentación.

#### Documentación de Infraestructura
Esta documentación proporciona una visión completa de la infraestructura tecnológica, incluyendo arquitectura, especificaciones técnicas, configuraciones de red y políticas de seguridad. Sirve como fuente de referencia única para el equipo técnico y garantiza la consistencia en la gestión de sistemas.

```
documentacion/
└── 📁 infraestructura/
    ├── 📁 diagramas-arquitectura/
    │   ├── 📄 arquitectura-sistema-v1.0.pdf
    │   ├── 📄 diagrama-red-topologia.drawio
    │   ├── 📄 flujo-datos.json
    │   └── 📄 despliegue-produccion.pptx
    │
    ├── 📁 especificaciones-servidores/
    │   ├── 📄 inventario-hardware.xlsx
    │   ├── 📄 specs-servidores-fisicos.md
    │   ├── 📄 config-vmware-esxi.txt
    │   └── 📄 almacenamiento-san.pdf
    │
    ├── 📁 configuraciones-red/
    │   ├── 📄 config-router-principal.backup
    │   ├── 📄 esquema-ip-vlan.xlsx
    │   ├── 📄 reglas-firewall.csv
    │   └── 📄 dns-records.txt
    │
    └── 📁 politicas-seguridad/
        ├── 📄 politica-acceso.md
        ├── 📄 hardening-baseline.conf
        ├── 📄 respuesta-incidentes.pdf
        ├── 📄 compliance-pci-dss.docx
        └── 📄 backup-policy-v2.1.md
```
#### Documentación de Aplicación
Esta documentación proporciona información completa sobre el desarrollo, funcionamiento y mantenimiento de las aplicaciones. Sirve como guía de referencia para desarrolladores, QA y equipos de operaciones, facilitando el ciclo de vida completo del software.

```
documentacion/
└── 📁 aplicacion/
    ├── 📁 desarrollo/
    │   ├── 📁 arquitectura/
    │   ├── 📁 codigo-fuente/
    │   ├── 📁 decisiones-tecnicas/
    │   └── 📁 guias-estilo/
    │
    ├── 📁 pruebas/
    │   ├── 📁 casos-prueba/
    │   ├── 📁 resultados/
    │   ├── 📁 automatizacion/
    │   └── 📁 rendimiento/
    │
    ├── 📁 despliegue/
    │   ├── 📁 entornos/
    │   ├── 📁 configuraciones/
    │   ├── 📁 scripts/
    │   └── 📁 pipelines/
    │
    ├── 📁 operacion/
    │   ├── 📁 monitoreo/
    │   ├── 📁 procedimientos/
    │   ├── 📁 incidentes/
    │   └── 📁 backup/
    │
    └── 📁 manuales/
        ├── 📁 usuario-final/
        ├── 📁 administrador/
        ├── 📁 tecnico/
        └── 📁 api/
```
#### Documentación Operativa
Esta documentación proporciona procedimientos y guías para la operación diaria de sistemas y servicios. Está diseñada para garantizar la continuidad operacional, estandarizar procedimientos y facilitar la resolución eficiente de incidencias.

```
documentacion/
└── 📁 operativa/
    ├── 📁 procedimientos-diarios/
    │   ├── 📁 checklist/
    │   ├── 📁 turnos/
    │   ├── 📁 reportes/
    │   └── 📁 handover/
    │
    ├── 📁 monitoreo/
    │   ├── 📁 alertas/
    │   ├── 📁 dashboards/
    │   ├── 📁 metricas/
    │   └── 📁 thresholds/
    │
    ├── 📁 incidentes/
    │   ├── 📁 runbooks/
    │   ├── 📁 escalamientos/
    │   ├── 📁 resolucion/
    │   └── 📁 postmortem/
    │
    ├── 📁 cambios/
    │   ├── 📁 procedimientos/
    │   ├── 📁 ventanas/
    │   ├── 📁 rollback/
    │   └── 📁 aprobaciones/
    │
    └── 📁 comunicacion/
        ├── 📁 notificaciones/
        ├── 📁 contactos/
        ├── 📁 on-call/
        └── 📁 escalamiento/
```
### 4.3. Plantillas y automatización

Diseñar un protocolo de documentación basado en plantillas y procesos automatizados garantiza la consistencia, completitud y calidad en todos los materiales generados, facilitando su creación y mantenimiento. Este enfoque no solo mejora la documentación técnica dirigida a desarrolladores y administradores, sino también la destinada a usuarios finales y responsables operativos.

Buenas prácticas:

- **Trabajar con plantillas suficientemente descriptivas**: definir apartados mínimos como requisitos, instalación, configuración, arquitectura, incidencias conocidas y referencias, asegurando que no se omita información crítica.  
- **Usar herramientas que generen documentación a partir de comentarios en el código** (JSDoc, PHPDoc, entre otras): esto reduce el esfuerzo manual y mantiene sincronizada la documentación técnica con la implementación real.  
- **Incluir validación de documentación en los pipelines de integración continua**: integrar comprobaciones automáticas sobre formato, coherencia y existencia de documentación en cada versión publicada.  
- **Crear scripts que automaticen la actualización de versiones y changelogs**: mantener un registro histórico claro de cambios, correcciones y nuevas funcionalidades.  
- **Recoger feedback de los usuarios de la documentación**: tanto usuarios finales como técnicos deben poder aportar mejoras y señalar carencias.  
- **Medir la utilidad de la documentación mediante encuestas y análisis de uso**: identificar apartados más consultados y detectar lagunas informativas.  
- **Publicar la documentación en formatos accesibles y centralizados**: portales web, wikis internas, repositorios vinculados al código o manuales descargables en PDF, de forma que siempre exista una referencia única y actualizada.  
- **Mantener un estilo uniforme en el lenguaje y la estructura**: unificar redacción, terminología y formato visual para transmitir claridad y profesionalidad.  

Elementos recomendados en las plantillas de documentación:

- **Documentación técnica**:  
    - Descripción del proyecto y responsables.  
    - Requisitos de hardware, software y dependencias.  
    - Procedimientos de instalación y despliegue en distintos entornos.  
    - Arquitectura del sistema y diagramas de referencia.  
    - Variables de configuración, parámetros y personalización.  
    - Registro de cambios (changelog).  
    - Troubleshooting y resolución de incidencias frecuentes.  

- **Guías operativas**:  
    - Procedimientos de monitorización y mantenimiento rutinario.  
    - Políticas de copias de seguridad y recuperación ante fallos.  
    - Escalamiento de incidencias y responsables de soporte.  
    - Buenas prácticas de seguridad y cumplimiento normativo.  

- **Manuales de usuario**:  
    - Introducción al sistema y objetivos principales.  
    - Instrucciones paso a paso para tareas comunes.  
    - Capturas, diagramas o ejemplos ilustrativos.  
    - Preguntas frecuentes (FAQ).  
    - Contactos o canales de soporte.  

La combinación de plantillas y automatización fomenta una **cultura de documentación continua** que acompaña al ciclo de vida de la aplicación. De este modo, se cubren de forma integral las necesidades de desarrolladores, administradores y usuarios finales, asegurando que cada perfil disponga de la información necesaria en el momento oportuno.


 