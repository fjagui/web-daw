#!/bin/bash

# Script: git-manage-ignore.sh
# Descripción: Gestiona entradas en .gitignore y tracking de Git

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

# Función para verificar si está en .gitignore
is_in_gitignore() {
    local target="$1"
    if grep -q "^$target$" "$GITIGNORE" 2>/dev/null || 
       grep -q "^/$target$" "$GITIGNORE" 2>/dev/null || 
       grep -q "^$target/$" "$GITIGNORE" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Función para eliminar entrada del .gitignore
remove_from_gitignore() {
    local target="$1"
    local temp_file=$(mktemp)
    
    # Eliminar todas las variantes de la entrada
    grep -v "^$target$" "$GITIGNORE" | \
    grep -v "^/$target$" | \
    grep -v "^$target/$" | \
    grep -v "/$target$" > "$temp_file"
    
    mv "$temp_file" "$GITIGNORE"
}

# Verificar que se proporcionó un argumento
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

TARGET="$1"
GITIGNORE=".gitignore"
ACTION=""
COMMIT_MESSAGE=""

# Verificar que estamos en un repositorio Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}Error: No estás dentro de un repositorio Git${NC}"
    exit 1
fi

# Verificar si el .gitignore existe, si no crearlo
if [ ! -f "$GITIGNORE" ]; then
    touch "$GITIGNORE"
fi

# Paso 1: Verificar si ya está en .gitignore
echo -e "${GREEN}Verificando '$TARGET' en $GITIGNORE...${NC}"

if is_in_gitignore "$TARGET"; then
    echo -e "${YELLOW}✓ '$TARGET' está en $GITIGNORE - ELIMINANDO${NC}"
    ACTION="remove"
else
    echo -e "${YELLOW}✗ '$TARGET' no está en $GITIGNORE - AÑADIENDO${NC}"
    ACTION="add"
fi

# Paso 2: Ejecutar la acción correspondiente
if [ "$ACTION" = "add" ]; then
    # Añadir al .gitignore
    echo -e "${GREEN}Añadiendo '$TARGET' al $GITIGNORE...${NC}"
    echo "" >> "$GITIGNORE"
    echo "# Añadido automáticamente $(date '+%Y-%m-%d %H:%M:%S')" >> "$GITIGNORE"
    echo "$TARGET" >> "$GITIGNORE"
    echo -e "${GREEN}✓ '$TARGET' añadido a $GITIGNORE${NC}"
    COMMIT_MESSAGE="Añadir $TARGET al .gitignore"
    
else
    # Eliminar del .gitignore
    echo -e "${GREEN}Eliminando '$TARGET' de $GITIGNORE...${NC}"
    remove_from_gitignore "$TARGET"
    echo -e "${GREEN}✓ '$TARGET' eliminado de $GITIGNORE${NC}"
    COMMIT_MESSAGE="Eliminar $TARGET del .gitignore"
fi

# Paso 3: Gestionar el tracking de Git
echo -e "${GREEN}Gestionando tracking de '$TARGET'...${NC}"

if git ls-files --error-unmatch "$TARGET" > /dev/null 2>&1; then
    echo -e "${YELLOW}✓ '$TARGET' está siendo trackeado - ELIMINANDO${NC}"
    git rm --cached -r "$TARGET"
    echo -e "${GREEN}✓ '$TARGET' eliminado del tracking${NC}"
    
    # Actualizar mensaje de commit si también se modificó el tracking
    if [ "$ACTION" = "add" ]; then
        COMMIT_MESSAGE="Añadir $TARGET al .gitignore y eliminar del tracking"
    else
        COMMIT_MESSAGE="Eliminar $TARGET del .gitignore y del tracking"
    fi
else
    echo -e "${YELLOW}✗ '$TARGET' no está siendo trackeado${NC}"
fi

# Paso 4: Hacer commit y push automáticamente
echo -e "${GREEN}Sincronizando con repositorio remoto...${NC}"

# Añadir .gitignore al staging
git add .

# Verificar si hay cambios para commit
if ! git diff --cached --quiet || ! git diff --quiet; then
    git commit -m "$COMMIT_MESSAGE"
    echo -e "${GREEN}✓ Commit realizado: $COMMIT_MESSAGE${NC}"
    
    # Hacer push al repositorio remoto
    git push
    echo -e "${GREEN}✓ Push realizado${NC}"
else
    echo -e "${YELLOW}No hay cambios para commit${NC}"
fi

# Paso 5: Mostrar estado final
echo -e "\n${BLUE}=== RESULTADO FINAL ===${NC}"
echo -e "${GREEN}Acción realizada: ${NC}$ACTION"
echo -e "${GREEN}En .gitignore: ${NC}$(is_in_gitignore "$TARGET" && echo "✓ PRESENTE" || echo "✗ AUSENTE")"
echo -e "${GREEN}En tracking Git: ${NC}$(git ls-files --error-unmatch "$TARGET" >/dev/null 2>&1 && echo "✓ TRACKEADO" || echo "✗ NO TRACKEADO")"

echo -e "\n${GREEN}✅ Proceso completado!${NC}"
