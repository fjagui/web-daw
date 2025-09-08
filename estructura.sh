#!/bin/bash

# Carpeta raíz del curso
ROOT="./"
DOCS="$ROOT/docs"

# Unidades con nombres legibles y contenidos básicos agrupados (con encabezados ###)
declare -A UNIDADES
UNIDADES["UD1-implantacion-arquitecturas-web"]=$'# Implantación de arquitecturas web\n\n## Contenidos básicos agrupados\n\n### Arquitecturas web\n- Modelos, características, ventajas e inconvenientes.\n\n### Servidores\n- Servidores web: instalación y configuración básica.\n- Servidores de aplicaciones: instalación y configuración básica.\n\n### Virtualización\n- Tecnologías de virtualización en la nube.\n- Tecnologías de virtualización en contenedores.\n- Instalación y configuración básica.\n\n### Aplicaciones web\n- Estructura y recursos que las componen.\n\n### Documentación\n- Procesos de instalación y configuración realizados.\n\n## Resultados de aprendizaje\n(Completar aquí)\n\n## Criterios de evaluación\n(Completar aquí)\n'

UNIDADES["UD2-administracion-servidores-web"]=$'# Administración de servidores web\n\n## Contenidos básicos agrupados\n\n### Configuración avanzada\n- Parámetros del servidor web.\n- Hosts virtuales.\n- Módulos: instalación, configuración y uso.\n\n### Seguridad\n- Autenticación y control de acceso.\n- Protocolo HTTPS.\n- Certificados digitales y autoridades certificadoras.\n\n### Despliegue de aplicaciones\n- Implantación en servidores web.\n- Uso de virtualización en la nube y contenedores.\n\n### Gestión de logs\n- Herramientas de monitorización, consolidación y análisis en tiempo real (Big Data).\n\n### Documentación\n- Configuración, administración segura y recomendaciones de uso.\n\n## Resultados de aprendizaje\n(Completar aquí)\n\n## Criterios de evaluación\n(Completar aquí)\n'

UNIDADES["UD3-administracion-servidores-aplicaciones"]=$'# Administración de servidores de aplicaciones\n\n## Contenidos básicos agrupados\n\n### Arquitectura del servidor de aplicaciones\n- Componentes, servicios y archivos de configuración.\n\n### Administración\n- Gestión de aplicaciones web.\n- Administración de sesiones.\n- Cooperación entre servidor de aplicaciones y servidor web.\n\n### Seguridad\n- Dominios de seguridad.\n- Autenticación de usuarios.\n\n### Despliegue de aplicaciones\n- Procedimientos de instalación en el servidor de aplicaciones.\n- Uso de virtualización en la nube y contenedores.\n\n### Documentación\n- Administración y recomendaciones de uso.\n\n## Resultados de aprendizaje\n(Completar aquí)\n\n## Criterios de evaluación\n(Completar aquí)\n'

UNIDADES["UD4-servidores-transferencia-archivos"]=$'# Servidores de transferencia de archivos\n\n## Contenidos básicos agrupados\n\n### Instalación y configuración\n- Servidores de transferencia de archivos.\n- Permisos y cuotas.\n- Usuarios y accesos.\n\n### Conexiones\n- Modos de conexión: activo y pasivo.\n- Clientes: en línea de comandos y gráficos.\n\n### Seguridad\n- Protocolos seguros de transferencia de archivos (SFTP/FTPS).\n- Servicios de transferencia integrados en servidores web.\n\n### Despliegue\n- Uso en el despliegue de aplicaciones web.\n- Virtualización en la nube y contenedores.\n\n### Documentación\n- Configuración y administración del servicio.\n\n## Resultados de aprendizaje\n(Completar aquí)\n\n## Criterios de evaluación\n(Completar aquí)\n'

UNIDADES["UD5-servicios-red-aplicaciones-web"]=$'# Servicios de red implicados en aplicaciones web\n\n## Contenidos básicos agrupados\n\n### Sistema de nombres de dominio (DNS)\n- Estructura jerárquica y nomenclatura.\n- Resolución de nombres y registros.\n- Configuración de servidores de nombres para aplicaciones web.\n\n### Servicio de directorios\n- Características y elementos.\n- Archivos básicos de configuración.\n- Autenticación de usuarios.\n- Personalización de la configuración para aplicaciones web.\n\n### Despliegue\n- Uso de virtualización en la nube y contenedores.\n\n### Documentación\n- Adaptaciones realizadas en los servicios de red.\n\n## Resultados de aprendizaje\n(Completar aquí)\n\n## Criterios de evaluación\n(Completar aquí)\n'

UNIDADES["UD6-documentacion-control-versiones"]=$'# Documentación, control de versiones e integración continua\n\n## Contenidos básicos agrupados\n\n### Documentación\n- Herramientas colaborativas.\n- Creación y uso de plantillas.\n- Formatos de documentación.\n\n### Control de versiones\n- Instalación y configuración.\n- Operaciones avanzadas.\n- Seguridad de la información y del código.\n- Documentación de instalación, configuración y uso.\n\n### Integración continua\n- Instalación, configuración y uso.\n- Monitorización continua de métricas de calidad.\n\n## Resultados de aprendizaje\n(Completar aquí)\n\n## Criterios de evaluación\n(Completar aquí)\n'

# Crear estructura base
echo "📂 Creando estructura en $ROOT ..."
mkdir -p "$DOCS/recursos"

# Archivos principales
cat > "$DOCS/index.md" <<EOF
# Curso: Implantación de Aplicaciones Web

Bienvenido/a al curso.  
Duración: **50 horas**.

En el menú lateral puedes acceder a cada unidad didáctica, prácticas y recursos.
EOF

cat > "$DOCS/introduccion.md" <<EOF
# Introducción

En este documento encontrarás:
- Objetivos del curso
- Entorno de trabajo recomendado
- Requisitos previos
EOF

# Recursos
cat > "$DOCS/recursos/plantillas.md" <<EOF
# Plantillas

Aquí se incluirán las plantillas para documentación y proyectos.
EOF

cat > "$DOCS/recursos/scripts.md" <<EOF
# Scripts

Scripts de apoyo para las prácticas.
EOF

cat > "$DOCS/recursos/bibliografia.md" <<EOF
# Bibliografía y Recursos

Listado de recursos y referencias utilizadas en el curso.
EOF

# Crear carpetas y archivos de cada unidad
for UNIDAD in "${!UNIDADES[@]}"; do
  echo "   ➡️ Creando $UNIDAD ..."
  mkdir -p "$DOCS/$UNIDAD"

  # index.md con contenidos agrupados y encabezados
  echo -e "${UNIDADES[$UNIDAD]}" > "$DOCS/$UNIDAD/index.md"

  # practicas.md
  cat > "$DOCS/$UNIDAD/practicas.md" <<EOF
# Prácticas - ${UNIDADES[$UNIDAD]%%$'\n'*}

## Prácticas guiadas
(Completar aquí las prácticas guiadas)

## Prácticas por completar
(Completar aquí las prácticas semi-guiadas)

## Prácticas libres
(Completar aquí las prácticas libres)
EOF

  # soluciones.md
  cat > "$DOCS/$UNIDAD/soluciones.md" <<EOF
# Soluciones - ${UNIDADES[$UNIDAD]%%$'\n'*}

## Soluciones a prácticas guiadas
(Completar aquí las soluciones de prácticas guiadas)

## Soluciones a prácticas por completar
(Completar aquí las soluciones de prácticas semi-guiadas)

## Soluciones a prácticas libres
(Completar aquí las soluciones de prácticas libres)
EOF
done

echo "✅ Estructura del curso creada en $ROOT"
