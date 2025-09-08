#!/bin/bash

# Script: git-remove-from-ignore.sh
# Descripción: Elimina entradas del .gitignore sin preguntas interactivas

set -e  # Salir inmediatamente si algún comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo -e "${GREEN}Uso: $0 [archivo_o_directorio]${NC}"
    echo "Ejemplos:"
    echo "  $0 archivo.conf"
    echo "  $0 directorio/"
    echo "  $0 \"*.log\""
    echo -e "${YELLOW}Nota: Usa comillas para patrones con asteriscos${NC}"
}

# Función para eliminar entrada del .gitignore
remove_from_gitignore() {
    local target="$1"
    local temp_file=$(mktemp)
    
    # Eliminar la línea exacta y líneas relacionadas
    grep -v "^$target$" "$GITIGNORE" | \
    grep -v "^/$target$" | \
    grep -v "^$target/$" | \
    grep -v "/$target$" > "$temp_file"
    
    # Mover el archivo temporal al original
    mv "$temp_file" "$GITIGNORE"
}

# Verificar que se proporcionó un argumento
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

TARGET="$1"
GITIGNORE=".gitignore"

# Verificar que estamos en un repositorio Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}Error: No estás dentro de un repositorio Git${NC}"
    exit 1
fi

# Verificar si el .gitignore existe
if [ ! -f "$GITIGNORE" ]; then
    echo -e "${YELLOW}El archivo $GITIGNORE no existe. Nada que eliminar.${NC}"
    exit 0
fi

# Paso 1: Verificar si está en .gitignore
echo -e "${GREEN}Verificando '$TARGET' en $GITIGNORE...${NC}"

FOUND_ENTRIES=$(grep -n "$TARGET" "$GITIGNORE" 2>/dev/null | wc -l)

if [ "$FOUND_ENTRIES" -gt 0 ]; then
    echo -e "${YELLOW}✓ Se encontraron $FOUND_ENTRIES entradas para '$TARGET'${NC}"
    
    # Mostrar las entradas que se eliminarán
    echo -e "${BLUE}Entradas a eliminar:${NC}"
    grep -n "$TARGET" "$GITIGNORE"
    
    # Eliminar las entradas
    remove_from_gitignore "$TARGET"
    
    echo -e "${GREEN}✓ Entradas de '$TARGET' eliminadas de $GITIGNORE${NC}"
    
    # Mostrar contenido actualizado
    echo -e "${BLUE}Contenido actualizado de $GITIGNORE:${NC}"
    if [ -s "$GITIGNORE" ]; then
        cat -n "$GITIGNORE"
    else
        echo -e "${YELLOW}(archivo vacío)${NC}"
    fi
    
else
    echo -e "${YELLOW}✗ No se encontraron entradas para '$TARGET' en $GITIGNORE${NC}"
    echo -e "${GREEN}✓ Nada que hacer${NC}"
fi

echo -e "\n${GREEN}✅ Proceso completado!${NC}"
