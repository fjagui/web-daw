#!/bin/bash

# Script: git-manage-ignore.sh
# Descripción: Gestiona archivos en .gitignore y los muestra después de añadirlos

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

# Función para verificar si un patrón ya está en .gitignore
is_in_gitignore() {
    local target="$1"
    # Verificar diferentes formatos comunes en .gitignore
    if grep -q "^$target$" "$GITIGNORE" 2>/dev/null || 
       grep -q "^/$target$" "$GITIGNORE" 2>/dev/null || 
       grep -q "^$target/$" "$GITIGNORE" 2>/dev/null ||
       grep -q "/$target$" "$GITIGNORE" 2>/dev/null ||
       grep -q "[[:space:]]*$target[[:space:]]*" "$GITIGNORE" 2>/dev/null; then
        return 0  # true - ya está en .gitignore
    else
        return 1  # false - no está en .gitignore
    fi
}

# Función para mostrar una sección del .gitignore
show_gitignore_section() {
    local target="$1"
    echo -e "\n${BLUE}=== CONTENIDO ACTUALIZADO DE .GITIGNORE ===${NC}"
    echo -e "${YELLOW}# Entradas relacionadas con '$target':${NC}"
    
    # Mostrar líneas relacionadas con el target
    if grep -n "$target" "$GITIGNORE" 2>/dev/null; then
        echo -e "${GREEN}✓ Se encontraron entradas para '$target'${NC}"
    else
        echo -e "${YELLOW}⚠ No se encontraron entradas específicas para '$target'${NC}"
    fi
    
    echo -e "${BLUE}=========================================${NC}"
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

# Verificar si el .gitignore existe, si no crearlo
if [ ! -f "$GITIGNORE" ]; then
    echo -e "${YELLOW}El archivo $GITIGNORE no existe. Creándolo...${NC}"
    touch "$GITIGNORE"
    echo -e "${GREEN}✓ $GITIGNORE creado${NC}"
fi

# Paso 1: Verificar si ya está en .gitignore
echo -e "${GREEN}1. Verificando '$TARGET' en $GITIGNORE...${NC}"

if is_in_gitignore "$TARGET"; then
    echo -e "${YELLOW}   ✓ '$TARGET' ya está en $GITIGNORE${NC}"
    ALREADY_IN_GITIGNORE=true
else
    echo -e "${YELLOW}   ✗ '$TARGET' no está en $GITIGNORE${NC}"
    ALREADY_IN_GITIGNORE=false
fi

# Paso 2: Añadir al .gitignore si no está
if [ "$ALREADY_IN_GITIGNORE" = false ]; then
    echo -e "${GREEN}2. Añadiendo '$TARGET' al $GITIGNORE...${NC}"
    
    # Añadir línea en blanco si el archivo no termina con nueva línea
    if [ -s "$GITIGNORE" ] && [ "$(tail -c 1 "$GITIGNORE")" != "" ]; then
        echo "" >> "$GITIGNORE"
    fi
    
    # Añadir comentario y la entrada
    echo "# Añadido automáticamente $(date '+%Y-%m-%d %H:%M:%S')" >> "$GITIGNORE"
    echo "$TARGET" >> "$GITIGNORE"
    echo -e "${GREEN}   ✓ '$TARGET' añadido exitosamente a $GITIGNORE${NC}"
    
    # Mostrar confirmación visual
    echo -e "${BLUE}Contenido añadido:${NC}"
    tail -3 "$GITIGNORE"
else
    echo -e "${GREEN}   ✓ '$TARGET' ya estaba en $GITIGNORE, no se necesita añadir${NC}"
fi

# Paso 3: Verificar si el archivo/directorio existe en el filesystem
echo -e "${GREEN}3. Verificando existencia de '$TARGET'...${NC}"

if [ -e "$TARGET" ] || [ -d "$TARGET" ] || [[ "$TARGET" == *"*"* ]]; then
    echo -e "${GREEN}   ✓ '$TARGET' existe o es un patrón válido${NC}"
else
    echo -e "${YELLOW}   ⚠ '$TARGET' no existe en el filesystem (puede ser un patrón)${NC}"
fi

# Paso 4: Verificar tracking de Git (manejo más robusto)
echo -e "${GREEN}4. Verificando estado de tracking para '$TARGET'...${NC}"

IS_TRACKED=false
if [[ "$TARGET" == *"*"* ]]; then
    # Para patrones con wildcards, verificar archivos que coincidan
    if ls $TARGET 2>/dev/null; then
        for file in $TARGET; do
            if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
                IS_TRACKED=true
                break
            fi
        done
    fi
else
    # Para archivos/directorios específicos
    if git ls-files --error-unmatch "$TARGET" >/dev/null 2>&1; then
        IS_TRACKED=true
    fi
fi

if [ "$IS_TRACKED" = true ]; then
    echo -e "${YELLOW}   ⚠ '$TARGET' está siendo trackeado por Git${NC}"
    echo -e "${YELLOW}   ¿Quieres eliminarlo del tracking? (s/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[SsYy]$ ]]; then
        if git rm --cached -r "$TARGET" 2>/dev/null; then
            echo -e "${GREEN}   ✓ Eliminado del tracking${NC}"
        else
            echo -e "${RED}   ✗ Error al eliminar del tracking${NC}"
        fi
    else
        echo -e "${YELLOW}   ✓ Se mantiene en tracking${NC}"
    fi
else
    echo -e "${GREEN}   ✓ '$TARGET' no está siendo trackeado${NC}"
fi

# Paso 5: Mostrar la sección relevante del .gitignore
show_gitignore_section "$TARGET"

# Paso 6: Mostrar estado actual de Git
echo -e "\n${GREEN}5. Estado actual del repositorio:${NC}"
git status --short

# Paso 7: Ofrecer hacer commit si hay cambios
if git diff --quiet --cached -- "$GITIGNORE" 2>/dev/null && [ "$IS_TRACKED" = false ]; then
    echo -e "${GREEN}   No hay cambios pendientes para commit${NC}"
else
    echo -e "\n${YELLOW}¿Quieres hacer commit de los cambios? (s/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[SsYy]$ ]]; then
        git add "$GITIGNORE"
        if [ "$ALREADY_IN_GITIGNORE" = false ]; then
            git commit -m "Añadir $TARGET al .gitignore"
        else
            git commit -m "Actualizar .gitignore para $TARGET"
        fi
        echo -e "${GREEN}✓ Commit realizado${NC}"
        
        # Preguntar por push
        echo -e "${YELLOW}¿Quieres hacer push al repositorio remoto? (s/n)${NC}"
        read -r push_response
        if [[ "$push_response" =~ ^[SsYy]$ ]]; then
            git push
            echo -e "${GREEN}✓ Push realizado${NC}"
        fi
    fi
fi

echo -e "\n${GREEN}✅ Proceso completado!${NC}"
echo -e "${YELLOW}Resumen:${NC}"
echo -e "  - En .gitignore: $( [ "$ALREADY_IN_GITIGNORE" = true ] && echo "✓ Ya estaba" || echo "✓ Añadido" )"
echo -e "  - Tracking Git: $( [ "$IS_TRACKED" = true ] && echo "⚠ Trackeado" || echo "✓ No trackeado" )"
