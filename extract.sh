#!/bin/bash

# Функція для запакування файлів в архіви
create_archive() {
    local file=$1
    local archive_format=$2

    # Перевірка, чи існує файл
    if [ ! -f "$file" ]; then
        echo "Файл $file не знайдено."
        return
    fi

    # Запакування в залежності від формату
    case "$archive_format" in
        zip)
            zip "$file.zip" "$file"
            echo "Запаковано $file в $file.zip"
            ;;
        tar)
            tar -cvf "$file.tar" "$file"
            echo "Запаковано $file в $file.tar"
            ;;
        tgz)
            tar -czvf "$file.tar.gz" "$file"
            echo "Запаковано $file в $file.tar.gz"
            ;;
        rar)
            rar a "$file.rar" "$file"
            echo "Запаковано $file в $file.rar"
            ;;
        *)
            echo "Невідомий формат для запаковки: $archive_format"
            ;;
    esac
}

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

