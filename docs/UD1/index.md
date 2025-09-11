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

### Virtualización
- Tecnologías de virtualización en la nube.
- Tecnologías de virtualización en contenedores.
- Instalación y configuración básica.

### Aplicaciones web
- Estructura y recursos que las componen.

### Documentación
- Procesos de instalación y configuración realizados.

## Resultados de aprendizaje
(Completar aquí)

## Criterios de evaluación
(Completar aquí)

