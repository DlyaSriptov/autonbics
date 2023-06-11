#!/bin/bash

netconf=Y
set_jitsi=Y
set_nbics=Y
set_check=Y

for ((;;))
do
    echo "Пожалуйста, ответьте на несколько вопросов:"
    echo "-------------------------------------------"
    echo "Настроить сеть (Y/N)?"
    read netconf
            
    echo "Установить Jitsi (Y/N)?"
    read set_jitsi
    
    echo "Установить NBICS (Y/N)?"
    read set_nbics
    
    echo "==================================="
    echo "Настройка сети - " $netconf
    echo "Установка Jitsi - " $set_jitsi
    echo "Установка NBICS - " $set_nbics
    
    echo "==================================="
    echo "                                   "
    echo "Всё правильно (Y/N)?"
    read set_check
    
    if [[ $set_check = Y ]]
    then
        break
    fi    
done

echo "Тестовый выход из цикла"

