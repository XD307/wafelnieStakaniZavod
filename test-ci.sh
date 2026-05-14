#!/bin/bash

echo "========================================="
echo "Тестирование CI/CD для Завода вафельных стаканчиков"
echo "========================================="
echo ""

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Счетчик ошибок
ERRORS=0

# 1. Проверка структуры папок
echo "1. Проверка структуры проекта..."
if [ -d "backend" ]; then
    echo -e "${GREEN}✓ Папка backend существует${NC}"
else
    echo -e "${RED}✗ Папка backend не найдена${NC}"
    ((ERRORS++))
fi

if [ -d "frontend" ]; then
    echo -e "${GREEN}✓ Папка frontend существует${NC}"
else
    echo -e "${RED}✗ Папка frontend не найдена${NC}"
    ((ERRORS++))
fi

if [ -d ".github/workflows" ]; then
    echo -e "${GREEN}✓ Папка .github/workflows существует${NC}"
else
    echo -e "${RED}✗ Папка .github/workflows не найдена${NC}"
    ((ERRORS++))
fi

echo ""

# 2. Проверка файлов бэкенда
echo "2. Проверка файлов бэкенда..."
if [ -f "backend/requirements.txt" ]; then
    echo -e "${GREEN}✓ backend/requirements.txt существует${NC}"
else
    echo -e "${RED}✗ backend/requirements.txt не найден${NC}"
    ((ERRORS++))
fi

if [ -f "backend/main.py" ]; then
    echo -e "${GREEN}✓ backend/main.py существует${NC}"
else
    echo -e "${RED}✗ backend/main.py не найден${NC}"
    ((ERRORS++))
fi

if [ -d "backend/tests" ]; then
    echo -e "${GREEN}✓ Папка backend/tests существует${NC}"
else
    echo -e "${RED}✗ Папка backend/tests не найдена${NC}"
    ((ERRORS++))
fi

if [ -f "backend/tests/test_main.py" ]; then
    echo -e "${GREEN}✓ backend/tests/test_main.py существует${NC}"
else
    echo -e "${YELLOW}⚠ backend/tests/test_main.py не найден (тесты не будут работать)${NC}"
fi

echo ""

# 3. Проверка файлов фронтенда
echo "3. Проверка файлов фронтенда..."
if [ -f "frontend/package.json" ]; then
    echo -e "${GREEN}✓ frontend/package.json существует${NC}"
else
    echo -e "${RED}✗ frontend/package.json не найден${NC}"
    ((ERRORS++))
fi

if [ -d "frontend/src" ]; then
    echo -e "${GREEN}✓ Папка frontend/src существует${NC}"
else
    echo -e "${RED}✗ Папка frontend/src не найдена${NC}"
    ((ERRORS++))
fi

if [ -f "frontend/src/App.js" ]; then
    echo -e "${GREEN}✓ frontend/src/App.js существует${NC}"
else
    echo -e "${RED}✗ frontend/src/App.js не найден${NC}"
    ((ERRORS++))
fi

echo ""

# 4. Проверка CI/CD файла
echo "4. Проверка CI/CD файла..."
if [ -f ".github/workflows/ci-cd.yml" ]; then
    echo -e "${GREEN}✓ .github/workflows/ci-cd.yml существует${NC}"
    
    # Проверка что файл не пустой
    if [ -s ".github/workflows/ci-cd.yml" ]; then
        echo -e "${GREEN}✓ Файл CI/CD не пустой${NC}"
    else
        echo -e "${RED}✗ Файл CI/CD пустой${NC}"
        ((ERRORS++))
    fi
else
    echo -e "${RED}✗ .github/workflows/ci-cd.yml не найден${NC}"
    ((ERRORS++))
fi

echo ""

# 5. Проверка валидности Python кода (если есть Python)
echo "5. Проверка Python кода..."
if command -v python &> /dev/null; then
    cd backend
    python -m py_compile main.py 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ main.py синтаксически верен${NC}"
    else
        echo -e "${RED}✗ Ошибка синтаксиса в main.py${NC}"
        ((ERRORS++))
    fi
    
    if [ -f "tests/test_main.py" ]; then
        python -m py_compile tests/test_main.py 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ test_main.py синтаксически верен${NC}"
        else
            echo -e "${RED}✗ Ошибка синтаксиса в test_main.py${NC}"
            ((ERRORS++))
        fi
    fi
    cd ..
else
    echo -e "${YELLOW}⚠ Python не установлен, проверка синтаксиса пропущена${NC}"
fi

echo ""

# 6. Проверка валидности package.json
echo "6. Проверка package.json..."
if command -v node &> /dev/null; then
    cd frontend
    node -e "require('./package.json')" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ package.json валиден${NC}"
    else
        echo -e "${RED}✗ Ошибка в package.json (невалидный JSON)${NC}"
        ((ERRORS++))
    fi
    cd ..
else
    echo -e "${YELLOW}⚠ Node.js не установлен, проверка package.json пропущена${NC}"
fi

echo ""

# 7. Симуляция GitHub Actions (простая проверка)
echo "7. Симуляция GitHub Actions проверок..."
echo "   (Проверяем что можно установить зависимости)"

# Проверка pip
if command -v pip &> /dev/null; then
    echo -e "${GREEN}✓ pip установлен${NC}"
else
    echo -e "${YELLOW}⚠ pip не найден${NC}"
fi

# Проверка npm
if command -v npm &> /dev/null; then
    echo -e "${GREEN}✓ npm установлен${NC}"
else
    echo -e "${YELLOW}⚠ npm не найден${NC}"
fi

echo ""

# Итог
echo "========================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ ВСЕ ПРОВЕРКИ ПРОЙДЕНЫ УСПЕШНО!${NC}"
    echo "${GREEN}   CI/CD должен работать на GitHub${NC}"
    echo ""
    echo "Следующие шаги:"
    echo "1. Залить код на GitHub"
    echo "2. Перейти во вкладку Actions"
    echo "3. Убедиться что все проверки зеленые"
else
    echo -e "${RED}❌ НАЙДЕНО ОШИБОК: $ERRORS${NC}"
    echo "${RED}   Исправьте ошибки перед заливкой на GitHub${NC}"
fi
echo "========================================="