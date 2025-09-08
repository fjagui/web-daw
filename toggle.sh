#!/bin/bash

# Script: toggle-unit-yml.sh
# Descripción: Comenta o descomenta una unidad en el archivo YAML

set -e  # Salir inmediatamente si algún comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo -e "${GREEN}Uso: $0 [número_unidad]${NC}"
    echo "Ejemplos:"
    echo "  $0 3    # Comenta/descomenta Unidad 3"
    echo "  $0 5    # Comenta/descomenta Unidad 5"
    echo -e "${YELLOW}Nota: El número debe estar entre 1 y 6${NC}"
}

# Función para comentar una unidad
comment_unit() {
    local unit_num=$1
    local yml_file=$2
    
    # Comentar la línea de la unidad y sus sub-líneas
    sed -i "/^  - Unidad $unit_num:/s/^  -/#  -/" "$yml_file"
    sed -i "/^      - Teoría: UD$unit_num\//s/^      -/#      -/" "$yml_file"
    sed -i "/^      - Actividades: UD$unit_num\//s/^      -/#      -/" "$yml_file"
    sed -i "/^      - RA y CE: UD$unit_num\//s/^      -/#      -/" "$yml_file"
}

# Función para descomentar una unidad
uncomment_unit() {
    local unit_num=$1
    local yml_file=$2
    
    # Descomentar la línea de la unidad y sus sub-líneas
    sed -i "/^#  - Unidad $unit_num:/s/^#  -/  -/" "$yml_file"
    sed -i "/^#      - Teoría: UD$unit_num\//s/^#      -/      -/" "$yml_file"
    sed -i "/^#      - Actividades: UD$unit_num\//s/^#      -/      -/" "$yml_file"
    sed -i "/^#      - RA y CE: UD$unit_num\//s/^#      -/      -/" "$yml_file"
}

# Función para verificar el estado de una unidad
check_unit_status() {
    local unit_num=$1
    local yml_file=$2
    
    if grep -q "^#  - Unidad $unit_num:" "$yml_file"; then
        echo "commented"
    elif grep -q "^  - Unidad $unit_num:" "$yml_file"; then
        echo "active"
    else
        echo "not_found"
    fi
}

# Verificar que se proporcionó un argumento
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

UNIT_NUM="$1"
YML_FILE="mkdocs.yml"  # Cambia esto por la ruta de tu archivo YAML

# Validar el número de unidad
if ! [[ "$UNIT_NUM" =~ ^[1-6]$ ]]; then
    echo -e "${RED}Error: El número de unidad debe estar entre 1 y 6${NC}"
    exit 1
fi

# Verificar que el archivo YAML existe
if [ ! -f "$YML_FILE" ]; then
    echo -e "${RED}Error: No se encuentra el archivo $YML_FILE${NC}"
    exit 1
fi

# Paso 1: Verificar el estado actual de la unidad
echo -e "${GREEN}Verificando estado de Unidad $UNIT_NUM...${NC}"

STATUS=$(check_unit_status "$UNIT_NUM" "$YML_FILE")

case "$STATUS" in
    "commented")
        echo -e "${YELLOW}✓ Unidad $UNIT_NUM está COMENTADA - DESCOMENTANDO${NC}"
        ACTION="uncomment"
        ;;
    "active")
        echo -e "${YELLOW}✓ Unidad $UNIT_NUM está ACTIVA - COMENTANDO${NC}"
        ACTION="comment"
        ;;
    "not_found")
        echo -e "${RED}✗ Unidad $UNIT_NUM no encontrada en el archivo${NC}"
        exit 1
        ;;
esac

# Paso 2: Ejecutar la acción correspondiente
if [ "$ACTION" = "comment" ]; then
    comment_unit "$UNIT_NUM" "$YML_FILE"
    echo -e "${GREEN}✓ Unidad $UNIT_NUM comentada${NC}"
else
    uncomment_unit "$UNIT_NUM" "$YML_FILE"
    echo -e "${GREEN}✓ Unidad $UNIT_NUM descomentada${NC}"
fi

# Paso 3: Mostrar cambios realizados
echo -e "\n${BLUE}=== CAMBIOS REALIZADOS ===${NC}"
echo -e "${GREEN}Líneas modificadas para Unidad $UNIT_NUM:${NC}"
grep -n "Unidad $UNIT_NUM\|UD$UNIT_NUM/" "$YML_FILE" | head -10

# Paso 4: Validar la sintaxis YAML (opcional)
echo -e "\n${GREEN}Validando sintaxis YAML...${NC}"
if command -v yamllint &> /dev/null; then
    if yamllint "$YML_FILE" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Sintaxis YAML válida${NC}"
    else
        echo -e "${YELLOW}⚠ Advertencia: Posible error de sintaxis YAML${NC}"
        echo -e "${YELLOW}Revisa manualmente el archivo$YML_FILE${NC}"
    fi
else
    echo -e "${YELLOW}ℹ yamllint no instalado, omitiendo validación${NC}"
fi

echo -e "\n${GREEN}✅ Proceso completado!${NC}"
echo -e "${YELLOW}Archivo modificado: $YML_FILE${NC}"
