#!/bin/bash

netconf=Y
set_jitsi=Y
set_nbics=Y
set_check=Y

for ((;;))
do
    echo "-------------------------------------------"
    echo "Пожалуйста, ответьте на несколько вопросов (Otvet'te na voprosy):"
    echo "-------------------------------------------"
    echo "Настроить сеть (Nastroit' seti) [Y/N]?"
    read netconf
            
    echo "Установить Jitsi (Ustanovit' Jitsi) [Y/N]?"
    read set_jitsi
    
    echo "Установить NBICS (Ustanovit' NBICS) [Y/N]?"
    read set_nbics
    
    echo "==================================="
    echo "Настройка сети (Nastrojka seti) - " $netconf
    echo "Установка Jitsi (Ustanovka Jitsi) - " $set_jitsi
    echo "Установка NBICS (Ustanovka NBICS) - " $set_nbics
    
    echo "==================================="
    echo "                                   "
    echo "Всё правильно (Everything is right) [Y/N]?"
    read set_check
    
    if [[ $set_check = Y ]]
    then
        break
    fi    
done

echo "Тестовый выход из цикла"

