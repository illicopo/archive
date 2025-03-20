Архіватор для Linux

Цей скрипт дозволяє працювати з архівами в Linux-системах. Він підтримує як створення архівів в різних форматах (rar, zip, tar, tgz), так і розпакування архівів. Скрипт автоматично визначає формат архіву та розпаковує його в ту ж саму папку.
Особливості:

    Створення архівів:
        Підтримка форматів: rar, zip, tar, tgz
        Легке додавання файлів до архівів через аргументи.
    Розпаковування архівів:
        Автоматичне розпакування архівів у директорію, де знаходиться сам архів.
        Підтримка форматів: .rar, .zip, .tar, .tgz
    Простота використання:
        Скрипт можна запустити через командний рядок без необхідності вказувати додаткові параметри для розпаковування.

Приклад використання:
Створення архіву:

    Запакувати файл file.txt у формат rar:

    ./extract.sh --rar file.txt

Запакувати файл file.txt у формат zip:

    ./extract.sh --zip file.txt

Розпаковка архіву:

    Розпакувати архів:

    ./extract.sh archive.rar

    Скрипт автоматично розпакує архів в ту ж саму директорію, де він знаходиться.

Вимоги:

    Для роботи з rar архівами, вам потрібно встановити пакунки rar або unrar.


```bash
#!/bin/bash

# Функція для розпаковки архівів
extract_archive() {
    local archive=$1
    local destination=$(dirname "$archive")  # Визначення поточної директорії архіву

    # Перевірка, чи існує архів
    if [ ! -f "$archive" ]; then
        echo "Файл $archive не знайдено."
        return
    fi

    # Створення директорії для розпаковки, якщо вона не існує
    if [ ! -d "$destination" ]; then
        mkdir -p "$destination"
    fi

    # Розпакування архіву в залежності від формату
    case "$archive" in
        *.zip)
            unzip "$archive" -d "$destination"
            echo "Розпаковано $archive в $destination"
            ;;
        *.tar)
            tar -xvf "$archive" -C "$destination"
            echo "Розпаковано $archive в $destination"
            ;;
        *.tar.gz | *.tgz)
            tar -xzvf "$archive" -C "$destination"
            echo "Розпаковано $archive в $destination"
            ;;
        *.rar)
            unrar x "$archive" "$destination/"
            echo "Розпаковано $archive в $destination"
            ;;
        *)
            echo "Невідомий формат архіву: $archive"
            ;;
    esac
}

# Перевірка аргументів
if [ "$1" == "--rar" ]; then
    if [ -z "$2" ]; then
        echo "Використання: $0 --rar <файл>"
        exit 1
    fi
    create_archive "$2" "rar"

elif [ "$1" == "--zip" ]; then
    if [ -z "$2" ]; then
        echo "Використання: $0 --zip <файл>"
        exit 1
    fi
    create_archive "$2" "zip"

elif [ "$1" == "--tar" ]; then
    if [ -z "$2" ]; then
        echo "Використання: $0 --tar <файл>"
        exit 1
    fi
    create_archive "$2" "tar"

elif [ "$1" == "--tgz" ]; then
    if [ -z "$2" ]; then
        echo "Використання: $0 --tgz <файл>"
        exit 1
    fi
    create_archive "$2" "tgz"

# Розпаковка архіву автоматично, якщо передано архів
else
    # Перевірка, чи передано файл
    if [ -z "$1" ]; then
        echo "Використання: $0 <архів>"
        exit 1
    fi
    # Викликаємо функцію розпаковки
    extract_archive "$1"
fi

