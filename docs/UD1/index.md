# Implantación de arquitecturas web

## Contenidos básicos agrupados

### Arquitecturas web
- Modelos, características, ventajas e inconvenientes.
### Arquitecturas web. Modelos, características, ventajas e inconvenientes

#### 1. Introducción a la Arquitectura Web

La arquitectura web es el esquema estructural y lógico que define cómo interactúan los diferentes componentes de una aplicación web (frontend, backend, bases de datos, servidores, etc.) para procesar una petición de usuario y entregar una respuesta.

La elección de una arquitectura adecuada es fundamental, ya que determina aspectos críticos del proyecto:

- **Escalabilidad:** Capacidad para crecer y manejar aumentos de carga
- **Mantenibilidad:** Facilidad para corregir errores y añadir nuevas funcionalidades
- **Rendimiento:** Velocidad y eficiencia en la respuesta
- **Fiabilidad y Disponibilidad:** Tolerancia a fallos y tiempo de actividad
- **Seguridad:** Protección de los datos y la infraestructura

A lo largo del tiempo, las arquitecturas han evolucionado desde modelos monolíticos simples hasta sistemas distribuidos y desacoplados complejos, impulsados por la necesidad de satisfacer demandas modernas.

#### 2. Modelos de Arquitectura

##### a) Arquitectura Monolítica

Es el modelo tradicional donde todos los componentes de la aplicación (interfaz de usuario, lógica de negocio, capa de acceso a datos) están acoplados en un único programa o proyecto y se despliegan como una sola unidad.

**Características:**
- Código único y base de código unificada
- Desarrollo, testing y despliegue simplificados al principio
- Comunicación entre componentes mediante llamadas a funciones o métodos internos (muy rápida)
- Generalmente, una única base de datos

**Ventajas:**
- ✅ **Simplicidad inicial:** Fácil de desarrollar, probar y desplegar
- ✅ **Desarrollo ágil:** Ideal para proyectos pequeños o MVPs (Producto Mínimo Viable)
- ✅ **Comunicación eficiente:** Al estar todo en el mismo proceso, la comunicación es directa y rápida

**Inconvenientes:**
- ❌ **Acoplamiento fuerte:** Un cambio pequeño puede requerir redeploy de toda la aplicación
- ❌ **Escalabilidad limitada:** Para escalar, se debe duplicar la aplicación completa
- ❌ **Barrera tecnológica:** Dificulta la adopción de nuevas tecnologías o frameworks
- ❌ **Baja fiabilidad:** Un fallo en un módulo pequeño puede tumbar toda la aplicación

**Caso de uso ideal:** Aplicaciones pequeñas, con poca carga, equipos de desarrollo reducidos y tiempo de salida al mercado crítico.

##### b) Arquitectura de 2 Capas (Cliente-Servidor)

Es el modelo clásico donde las responsabilidades se separan en dos partes claramente diferenciadas:

1. **Cliente ("Frontend"):** Solicita y presenta la información al usuario
2. **Servidor ("Backend"):** Procesa las peticiones, ejecuta la lógica de negocio y gestiona el acceso a los datos

**Características:**
- Separación clara de responsabilidades
- El servidor suele albergar tanto la lógica de negocio como la base de datos

**Ventajas:**
- ✅ **Mejor organización** que un monolito puro
- ✅ **Centralización:** La gestión y la seguridad son más fáciles de aplicar en el servidor

**Inconvenientes:**
- ❌ El servidor puede convertirse en un cuello de botella
- ❌ La escalabilidad sigue siendo un desafío

##### c) Arquitectura de 3 Capas / N-Capas

Este modelo divide la aplicación en tres capas lógicas y físicas independientes:

1. **Capa de Presentación (Frontend):** Interfaz de usuario que interactúa con el cliente
2. **Capa de Lógica de Negocio (Backend/Aplicación):** Contiene las reglas y procesos del negocio
3. **Capa de Datos (Base de Datos):** Almacena, recupera y gestiona la información

**Características:**
- Desacoplamiento total entre la presentación, la lógica y los datos
- Cada capa puede ser desarrollada, escalada y actualizada de forma independiente

**Ventajas:**
- ✅ **Alta escalabilidad:** Cada capa puede escalarse por separado
- ✅ **Mantenibilidad:** Los cambios en una capa no afectan a las otras
- ✅ **Mayor seguridad:** Es más fácil aplicar políticas de seguridad entre capas
- ✅ **Flexibilidad tecnológica:** Se pueden usar diferentes tecnologías en cada capa

**Inconvenientes:**
- ❌ **Complejidad aumentada:** Mayor overhead en desarrollo y configuración
- ❌ **Latencia:** La comunicación entre capas introduce latencia

**Caso de uso ideal:** Aplicaciones empresariales medianas y grandes.

##### d) Arquitectura Microservicios

Evolución natural de la arquitectura de N-Capas, donde una aplicación se compone de un conjunto de servicios pequeños, independientes y altamente desacoplados.

**Características:**
- **Servicios independientes:** Cada microservicio tiene su propia base de datos
- **Fuerte desacoplamiento:** Fallos en un servicio no afectan a los demás
- **Gobernanza descentralizada:** Cada equipo puede elegir la tecnología más adecuada
- **Comunicación via API:** HTTP/REST, mensajes asíncronos

**Ventajas:**
- ✅ **Escalabilidad granular:** Se escala solo el servicio que lo necesita
- ✅ **Alta disponibilidad:** Un fallo está aislado en un servicio
- ✅ **Libertad tecnológica:** Elección de mejores herramientas para cada problema
- ✅ **Despliegues independientes:** Se puede desplegar un servicio sin afectar al resto

**Inconvenientes:**
- ❌ **Alta complejidad operativa:** Requiere orquestación de contenedores y monitorización
- ❌ **Overhead en la comunicación:** La latencia de red añade complejidad
- ❌ **Consistencia de datos eventual:** Difícil mantener transacciones ACID entre servicios
- ❌ **Mayor demanda de recursos:** Mayor consumo de memoria y CPU

**Caso de uso ideal:** Sistemas grandes y complejos con equipos numerosos.

##### e) Arquitectura Serverless (Sin Servidor)

Modelo donde el desarrollador no gestiona servidores. Se escribe código en forma de funciones que se ejecutan en respuesta a eventos.

**Características:**
- **Abstracción total del servidor:** No hay que aprovisionar o mantener servidores
- **Ejecución dirigida por eventos:** El código se activa solo cuando es necesario
- **Escalado automático y elástico:** De cero a miles de instancias de forma automática
- **Pago por uso:** Solo se paga por el tiempo de computación consumido

**Ventajas:**
- ✅ **Máxima escalabilidad:** Escalado automático e inherente
- ✅ **Reducción de costes operativos:** No hay costes por servidor inactivo
- ✅ **Enfoque en el código:** El equipo se centra únicamente en la lógica de negocio
- ✅ **Alta disponibilidad:** Los proveedores la ofrecen por defecto

**Inconvenientes:**
- ❌ **Vendor lock-in:** Alta dependencia del proveedor cloud
- ❌ **Cold starts:** La primera invocación puede tener latencia
- ❌ **Depuración compleja:** Es más difícil debuggear funciones distribuidas
- ❌ **Limitaciones de tiempo y recursos:** Tiempos de ejecución máximos

**Caso de uso ideal:** APIs backend, procesamiento de datos en tiempo real, tareas asíncronas.

#### 3. Conclusión y Tendencias

No existe una arquitectura "mejor" universalmente. La elección depende de factores como la complejidad del proyecto, el tamaño del equipo, los requisitos de escalabilidad, el presupuesto y el tiempo de entrega.

- **Monolito:** Comienza simple. Válido para muchos proyectos
- **Microservicios:** Adóptalo cuando la complejidad del monolito sea insostenible
- **Serverless:** Ideal para lógica event-driven y para descargar la gestión de infraestructura

La tendencia actual se dirige hacia arquitecturas híbridas que combinan lo mejor de cada modelo y hacia el uso de **contenedores** (Docker) y **orquestadores** (Kubernetes) como estándar para empaquetar, desplegar y gestionar aplicaciones modernas.
### Servidores
- Servidores web: instalación y configuración básica.
- Servidores de aplicaciones: instalación y configuración básica.
### Servidores

#### 1. Introducción a los Servidores Web y de Aplicaciones

En el contexto del despliegue de aplicaciones web, los servidores son componentes fundamentales que proporcionan los servicios necesarios para que las aplicaciones estén disponibles para los usuarios. Se distinguen principalmente dos tipos:

- **Servidores Web**: Gestionan peticiones HTTP/HTTPS y sirven contenido estático
- **Servidores de Aplicaciones**: Ejecutan la lógica de negocio y procesan contenido dinámico

En los años 2000 era común hablar de "Application Servers" (ej. JBoss, WebSphere, GlassFish, Tomcat en Java), que ofrecían todo en un mismo paquete:

Motor de ejecución de la aplicación

Gestión de sesiones

Seguridad

Conexión a bases de datos

Servicios de mensajería, etc.

En ese modelo, el servidor de aplicaciones era pesado y monolítico.

🔹 Ahora

El enfoque moderno tiende a separar responsabilidades:

Servidor web (Nginx, Apache, Caddy) → Sirve archivos estáticos, balancea carga, maneja TLS.

Servidor de aplicaciones ligero (Gunicorn, Uvicorn, PHP-FPM, RoadRunner) → Solo ejecuta la aplicación.

Servicios externos especializados → Bases de datos, colas (RabbitMQ, Kafka), caché (Redis), etc.

Esto hace que hoy casi no se hable de "servidor de aplicaciones" como concepto clásico, sino de "application runtime" o "application server lightweight".

🔹 Conclusión

👉 No han desaparecido, pero ya no se usan de la misma forma centralizada de antes.

En Java todavía existen servidores de aplicaciones tradicionales (WildFly, WebLogic), aunque muchos migraron a Spring Boot (que incluye un servidor embebido como Tomcat/Jetty).

En Python/PHP/Node.js se prefiere el modelo ligero: un proceso que corre la app + un reverse proxy delante.
#### 2. Servidores Web: Instalación y Configuración Básica

##### a) Concepto y Funcionalidad

Los servidores web son software diseñado para servir contenido a través del protocolo HTTP/HTTPS. Su función principal es recibir peticiones de clientes (navegadores) y devolver respuestas, que pueden ser:

- Archivos estáticos (HTML, CSS, JavaScript, imágenes)
- Contenido dinámico mediante integración con servidores de aplicaciones
- Redirecciones y reescrituras de URL

##### b) Principales Servidores Web

**Apache HTTP Server:**
- Software libre y de código abierto
- Módulos extensibles (mod_rewrite, mod_security, mod_ssl)
- Amplia documentación y comunidad
- Configuración mediante archivos .htaccess

**Nginx:**
- Alto rendimiento y bajo consumo de recursos
- Arquitectura orientada a eventos
- Ideal para servir contenido estático y como proxy inverso
- Configuración centralizada

**Microsoft IIS:**
- Integrado con el ecosistema Microsoft
- Soporte nativo para ASP.NET
- Interfaz gráfica de administración



### Virtualización
- Tecnologías de virtualización en la nube.
- Tecnologías de virtualización en contenedores.
- Instalación y configuración básica.

### Virtualización en la nube

#### 1. Fundamentos de la Virtualización

##### 1.1. Concepto y Definición
La virtualización es una tecnología que permite crear versiones virtuales de recursos físicos de computación, como servidores, almacenamiento, redes y dispositivos. Esta capa de abstracción posibilita:

- Ejecutar múltiples sistemas operativos simultáneamente en un mismo hardware físico
- Aislar entornos de ejecución entre diferentes aplicaciones
- Optimizar la utilización de recursos hardware
- Facilitar la portabilidad y migración de cargas de trabajo

##### 1.2. Componentes Clave de la Virtualización
- **Hypervisor (VMM - Virtual Machine Monitor)**: Software que crea y ejecuta máquinas virtuales
- **Máquina Virtual (VM)**: Entorno aislado que emula un sistema físico completo
- **Host**: Máquina física que aloja el hypervisor y las VMs
- **Guest**: Sistema operativo invitado que se ejecuta dentro de una VM
- **Recursos Virtualizados**: CPU, memoria, almacenamiento y red asignados a las VMs

#### 2. Tipos de Virtualización

##### 2.1. Virtualización de Servidores
**Virtualización Completa (Type 1 - Bare Metal):**
- Hypervisor instalado directamente sobre el hardware físico
- Ejemplos: VMware ESXi, Microsoft Hyper-V, Xen, KVM
- Mayor rendimiento y eficiencia
- Ideal para entornos productivos y empresariales

**Virtualización Hospedada (Type 2 - Hosted):**
- Hypervisor ejecutado sobre un sistema operativo host
- Ejemplos: VMware Workstation, Oracle VirtualBox, Parallels
- Mayor facilidad de uso y configuración
- Adecuado para desarrollo, testing y entornos desktop

##### 2.2. Virtualización de Containers
- **Contenedores**: Entornos ligeros que comparten el kernel del sistema operativo host
- **Docker**: Plataforma estándar para creación y gestión de contenedores
- **Kubernetes**: Sistema de orquestación de contenedores
- Ventajas: Mayor eficiencia, rápido despliegue y escalado automático

##### 2.3. Otras Formas de Virtualización
- **Virtualización de Red**: VLANs, redes definidas por software (SDN)
- **Virtualización de Almacenamiento**: SAN virtual, almacenamiento definido por software
- **Virtualización de Escritorios**: VDI (Virtual Desktop Infrastructure)

#### 3. Tecnologías de Hypervisor Principales

##### 3.1. VMware vSphere/ESXi
**Características:**
- Hypervisor tipo 1 de alto rendimiento
- Suite completa de herramientas de gestión (vCenter)
- Funciones avanzadas: vMotion, HA, DRS
- Amplio ecosistema de partners y compatibilidad

**Ventajas:**
- Estabilidad y madurez empresarial
- Herramientas avanzadas de gestión
- Buen soporte técnico y documentación

##### 3.2. Microsoft Hyper-V
**Características:**
- Hypervisor tipo 1 integrado en Windows Server
- Gestión mediante Windows Admin Center o System Center
- Integración con ecosistema Microsoft
- Licenciamiento incluido con Windows Server

**Ventajas:**
- Coste cero para entornos Windows existentes
- Buena integración con Active Directory
- Fácil gestión para administradores Windows

##### 3.3. KVM (Kernel-based Virtual Machine)
**Características:**
- Hypervisor tipo 1 integrado en el kernel Linux
- Solución open-source totalmente gratuita
- Gestión mediante libvirt, virt-manager, oVirt
- Alto rendimiento y escalabilidad

**Ventajas:**
- Coste cero de licencias
- Alto rendimiento cercano al metal
- Flexibilidad total de configuración

##### 3.4. Comparativa de Hypervisores
| Característica | VMware ESXi | Hyper-V | KVM |
|----------------|-------------|---------|-----|
| Tipo | Type 1 | Type 1 | Type 1 |
| Coste licencia | Alto | Medio (gratis con WS) | Gratuito |
| Rendimiento | Excelente | Muy bueno | Excelente |
| Facilidad uso | Alta | Media-Alta | Media |
| Soporte empresarial | Excelente | Muy bueno | Bueno (comercial) |

#### 4. Virtualización en Entornos Cloud

##### 4.1. Modelos de Servicio Cloud
**IaaS (Infrastructure as a Service):**
- Infraestructura virtualizada completa (VMs, redes, almacenamiento)
- Control total sobre el sistema operativo y aplicaciones
- Ejemplos: AWS EC2, Azure Virtual Machines, Google Compute Engine

**PaaS (Platform as a Service):**
- Plataforma de ejecución para aplicaciones
- Sin gestión de infraestructura subyacente
- Ejemplos: Heroku, Google App Engine, Azure App Service

**SaaS (Software as a Service):**
- Aplicaciones completas en la nube
- Sin gestión de infraestructura ni plataforma
- Ejemplos: Office 365, Salesforce, Gmail

##### 4.2. Principales Proveedores Cloud

**Amazon Web Services (AWS):**
- Líder del mercado en servicios cloud
- Amplia gama de servicios (más de 200)
- EC2 para máquinas virtuales, ECS/EKS para contenedores
- Modelo de precios bajo demanda

**Microsoft Azure:**
- Integración perfecta con productos Microsoft
- Azure Virtual Machines, Azure Kubernetes Service
- Fuertes capacidades híbridas con Azure Stack
- Licenciamiento flexible para entornos Microsoft

**Google Cloud Platform (GCP):**
- Fortalezas en big data y machine learning
- Google Compute Engine, Google Kubernetes Engine
- Red global de alto rendimiento
- Precios competitivos y descuentos por uso sostenido

#### 5. Implementación Práctica de Virtualización

##### 5.1. Creación de Máquinas Virtuales
**Parámetros de Configuración:**
- Asignación de recursos CPU y memoria
- Configuración de discos virtuales (tipo, tamaño, formato)
- Configuración de red (NAT, bridge, host-only)
- Dispositivos virtuales (CD-ROM, USB, gráficos)

**Consideraciones de Rendimiento:**
- Overallocation controlada de recursos
- Alineación de discos virtuales
- Drivers optimizados para el hypervisor
- Configuración adecuada de cache y buffers

##### 5.2. Herramientas de Gestión
**Interfaces Gráficas:**
- VMware vSphere Client
- Hyper-V Manager
- virt-manager (KVM)
- Oracle VM VirtualBox Manager

**Interfaces de Línea de Comando:**
- VMware ESXi CLI
- Hyper-V PowerShell
- virsh (KVM)
- Vagrant para gestión declarativa

**Plataformas de Gestión:**
- VMware vCenter
- Microsoft System Center
- oVirt/RHEV
- OpenStack

#### 6. Consideraciones de Seguridad en Virtualización

##### 6.1. Mejores Prácticas de Seguridad
- **Aislamiento**: Garantizar separación entre VMs
- **Hardening**: Configuración segura del hypervisor
- **Parches**: Mantener actualizado el hypervisor y VMs
- **Backup**: Estrategias de backup específicas para entornos virtualizados
- **Monitorización**: Detección de anomalías y comportamientos sospechosos

##### 6.2. Aspectos Específicos de Seguridad
- **VM Escape**: Prevención de escapes desde guest al host
- **Seguridad de la red virtual**: Configuración adecuada de VLANs y firewalls
- **Gestión de secretos**: Almacenamiento seguro de credenciales
- **Auditoría**: Logs y monitorización de actividad

#### 7. Ventajas y Desventajas de la Virtualización

##### 7.1. Ventajas Principales
- **Optimización de recursos**: Mayor utilización del hardware
- **Flexibilidad**: Rápido aprovisionamiento y escalado
- **Disponibilidad**: Alta disponibilidad y recuperación ante desastres
- **Aislamiento**: Separación de entornos y aplicaciones
- **Ahorro de costes**: Reducción de hardware físico y energía

##### 7.2. Desventajas y Consideraciones
- **Complejidad**: Curva de aprendizaje y gestión
- **Rendimiento**: Overhead por la capa de virtualización
- **Coste licencias**: Software y herramientas de gestión
- **Dependencia vendor**: Lock-in con tecnologías específicas
- **Seguridad**: Nuevos vectores de ataque específicos

#### 8. Tendencias y Futuro de la Virtualización

##### 8.1. Evolución Tecnológica
- **Containers y Kubernetes**: Mayor adopción de contenedores
- **Serverless Computing**: Abstractación completa de la infraestructura
- **Edge Computing**: Virtualización en entornos distribuidos
- **GPU Virtualization**: Virtualización de aceleradores hardware

##### 8.2. Tecnologías Emergentes
- **MicroVMs**: Máquinas virtuales ultraligeras (Firecracker)
- **Service Mesh**: Gestión avanzada de comunicaciones entre servicios
- **GitOps**: Gestión declarativa de infraestructura
- **Multi-cloud**: Gestión unificada de múltiples nubes

#### 9. Casos de Uso y Aplicaciones Prácticas

##### 9.1. Entornos de Desarrollo y Testing
- Entornos aislados y reproducibles
- Snapshots para testing de diferentes escenarios
- Templates para rápido aprovisionamiento

##### 9.2. Producción y Empresa
- Consolidación de servidores físicos
- Alta disponibilidad y balanceo de carga
- Recuperación ante desastres y backup
- Escalabilidad elástica según demanda

##### 9.3. Educación y Laboratorios
- Entornos de aprendizaje aislados
- Laboratorios virtuales complejos
- Democratización del acceso a infraestructura

#### 10. Conclusión

La virtualización en la nube representa la base fundamental de la computación moderna, permitiendo:

- Optimización radical del uso de recursos hardware
- Flexibilidad sin precedentes en el aprovisionamiento de infraestructura
- Capacidades avanzadas de alta disponibilidad y recuperación
- Transición hacia modelos cloud y hybrid cloud

La elección de la tecnología de virtualización adecuada depende de múltiples factores: requisitos técnicos, presupuesto, habilidades del equipo, y estrategia cloud a largo plazo. El futuro continúa hacia mayor abstractación, automatización y eficiencia en la gestión de recursos computacionales.

### Tecnologías de virtualización de contenedores

#### 1. Fundamentos de la Virtualización por Contenedores

##### 1.1. Concepto y Definición
La virtualización por contenedores es una tecnología de virtualización a nivel de sistema operativo que permite ejecutar múltiples instancias aisladas de aplicaciones (contenedores) compartiendo un mismo kernel del sistema operativo host.

**Características principales:**
- Aislamiento de procesos mediante namespaces
- Control de recursos mediante cgroups
- Imágenes inmutables y portables
- Arranque rápido y menor overhead que las VMs

##### 1.2. Diferencias con Virtualización Tradicional
| Aspecto | Virtualización Tradicional | Contenedores |
|---------|----------------------------|--------------|
| Nivel de abstractación | Hardware | Sistema operativo |
| Tamaño | GBs | MBs |
| Tiempo de inicio | Minutos | Segundos |
| Overhead | Alto (10-20%) | Bajo (1-5%) |
| Aislamiento | Completo (VM) | Procesos (OS) |

#### 2. Arquitectura de Contenedores

##### 2.1. Componentes Fundamentales
- **Container Engine**: Software que gestiona el ciclo de vida de contenedores
- **Imágenes**: Plantillas read-only que contienen la aplicación y sus dependencias
- **Contenedores**: Instancias ejecutables de las imágenes
- **Registry**: Repositorio para almacenar y distribuir imágenes
- **Orquestador**: Sistema para gestionar múltiples contenedores

##### 2.2. Namespaces y Cgroups
**Namespaces (Aislamiento):**
- PID: Aislamiento de procesos
- Network: Redes aisladas
- Mount: Sistemas de archivos independientes
- UTS: Hostname y domain name aislados
- IPC: Comunicación entre procesos aislada
- User: UIDs y GIDs aislados

**Cgroups (Control de recursos):**
- CPU: Límites de uso de procesador
- Memory: Límites de memoria RAM
- I/O: Control de acceso a disco
- Network: Ancho de banda de red

#### 3. Tecnologías Principales de Contenedores

##### 3.1. Docker
**Arquitectura Docker:**
- Docker Daemon: Servicio principal
- Docker Client: Interfaz de línea de comandos
- Docker Images: Plantillas de contenedores
- Docker Registry: Docker Hub y registros privados

**Componentes clave:**
- Dockerfile: Script para construir imágenes
- Docker Compose: Orquestación de múltiples contenedores
- Docker Swarm: Orquestación nativa de Docker

##### 3.2. Containerd
- Runtime de contenedores de bajo nivel
- Parte del proyecto CNCF (Cloud Native Computing Foundation)
- Base para Docker y Kubernetes
- API más simple y enfocada en la ejecución básica

##### 3.3. Podman
- Alternativa a Docker sin daemon
- Rootless containers (ejecución sin privilegios root)
- Compatible con Docker CLI
- Arquitectura sin daemon centralizado

##### 3.4. Comparativa de Tecnologías
| Tecnología | Empresa | Daemon | Rootless | Kubernetes Integration |
|------------|---------|---------|----------|-----------------------|
| Docker | Docker, Inc. | Sí | Parcial | Excelente |
| Containerd | CNCF | Sí | Sí | Nativa |
| Podman | Red Hat | No | Sí | Buena |

#### 4. Orquestación de Contenedores

##### 4.1. Kubernetes
**Arquitectura Kubernetes:**
- **Control Plane**: etcd, API Server, Controller Manager, Scheduler
- **Nodes**: kubelet, kube-proxy, container runtime
- **Pods**: Unidad mínima de despliegue (1+ contenedores)
- **Services**: Abstración de acceso a aplicaciones

**Conceptos clave:**
- Deployments: Gestión de aplicaciones stateless
- StatefulSets: Aplicaciones con estado
- ConfigMaps y Secrets: Configuración y datos sensibles
- Ingress: Gestión de tráfico entrante

##### 4.2. Docker Swarm
- Orquestación nativa de Docker
- Más simple que Kubernetes
- Integración transparente con ecosistema Docker
- Adecuado para entornos pequeños y medianos

##### 4.3. OpenShift
- Plataforma empresarial basada en Kubernetes
- Funcionalidades adicionales de seguridad y CI/CD
- Interfaz web robusta y herramientas de desarrollo
- Soporte empresarial de Red Hat

#### 5. Desarrollo y Construcción de Contenedores

##### 5.1. Dockerfile y Best Practices

### Aplicaciones web
- Estructura y recursos que las componen.
### 6. Seguridad en Contenedores

#### 6.1. Mejores Prácticas de Seguridad

- **Imágenes minimalistas**: Usar imágenes base pequeñas (alpine, distroless)
- **Escaneo de vulnerabilidades**: Tools like Trivy, Grype, Snyk
- **Non-root execution**: Ejecutar contenedores sin privilegios root
- **Read-only filesystems**: Montar sistemas de archivos como read-only
- **Resource limits**: Establecer límites de CPU y memoria

#### 6.2. Herramientas de Seguridad

- **Falco**: Detección de comportamientos anómalos
- **Notary**: Firma digital de imágenes
- **Aqua Security**: Plataforma completa de seguridad
- **Sysdig**: Monitorización y seguridad

### 7. Networking y Almacenamiento

#### 7.1. Modelos de Networking

- **Bridge network**: Red interna por defecto
- **Host network**: Compartir networking del host
- **Overlay network**: Redes multi-host (Docker Swarm, Kubernetes)
- **Macvlan**: Asignar dirección MAC directa

#### 7.2. Soluciones de Almacenamiento

- **Volumes**: Almacenamiento gestionado por Docker
- **Bind mounts**: Montar directorios del host
- **tmpfs mounts**: Almacenamiento en memoria
- **Storage plugins**: Integración con sistemas externos

### 8. Monitorización y Logging

#### 8.1. Herramientas de Monitorización

- **cAdvisor**: Monitorización de recursos de contenedores
- **Prometheus**: Sistema de monitorización y alerting
- **Grafana**: Dashboards de visualización
- **Datadog**: Plataforma SaaS de monitorización

#### 8.2. Estrategias de Logging

- **Driver de logs**: json-file, journald, syslog, fluentd
- **ELK Stack**: Elasticsearch, Logstash, Kibana
- **Loki**: Sistema de logging de Grafana
- **Fluentd**: Colector de logs unificado

### 9. Integración Continua y Despliegue

#### 9.1. CI/CD con Contenedores

- **GitHub Actions**: Automatización de builds y tests
- **GitLab CI**: Pipelines integradas con container registry
- **Jenkins**: Automatización con pipelines declarativas
- **ArgoCD**: GitOps para Kubernetes

#### 9.2. Estrategias de Despliegue

- **Blue-Green**: Dos entornos idénticos
- **Canary Releases**: Despliegue progresivo
- **Rolling Updates**: Actualización gradual
- **A/B Testing**: Variantes para diferentes usuarios

### 10. Tendencias y Futuro

#### 10.1. Tecnologías Emergentes

- **WebAssembly (Wasm)**: Ejecución portable y segura
- **eBPF**: Programabilidad del kernel para networking y seguridad
- **Serverless Containers**: Abstractación completa de la infraestructura
- **GitOps**: Gestión declarativa basada en Git

#### 10.2. Evolución del Ecosistema

- Mayor adopción de containerd y CRI-O
- Crecimiento de plataformas serverless basadas en containers
- Integración con service mesh (Istio, Linkerd)
- Avances en seguridad con hardware TPM y confidential computing

### 11. Casos de Uso y Aplicaciones

#### 11.1. Microservicios

- Descomposición de aplicaciones monolíticas
- Independencia en desarrollo y despliegue
- Escalabilidad granular por servicio

#### 11.2. DevOps y CI/CD

- Entornos consistentes de desarrollo a producción
- Builds reproducibles y versionados
- Automatización de testing y despliegue

#### 11.3. Machine Learning

- Empaquetado de modelos y dependencias
- Reproducibilidad de experimentos
- Escalabilidad de inferencia

### 12. Conclusión

La virtualización por contenedores ha revolucionado el desarrollo y despliegue de aplicaciones mediante:

- **Portabilidad**: Ejecución consistente en cualquier entorno
- **Eficiencia**: Mayor densidad de aplicaciones por recurso
- **Velocidad**: Desarrollo ágil y despliegues rápidos
- **Ecosistema**: Herramientas maduras y estándares abiertos

El futuro continúa hacia mayor abstractación, seguridad nativa y integración con cloud native technologies, manteniendo los principios de inmutabilidad, declaratividad y automatización que han hecho exitosa esta tecnología.


### Documentación
- Procesos de instalación y configuración realizados.

## Resultados de aprendizaje
(Completar aquí)

## Criterios de evaluación
(Completar aquí)

