#!/bin/bash

# Переменные для конфигурирования установки
q_netconf=Y
q_jitsi=Y
q_nbics=Y
q_check=Y

# Цикл конфигурирования установки
for ((;;))
do
    echo "-------------------------------------------"
    echo "Пожалуйста, ответьте на несколько вопросов (Otvet'te na voprosy):"
    echo "-------------------------------------------"
    echo "Настроить сеть (Nastroit' seti) [Y/N]?"
    read q_netconf
            
    echo "Установить Jitsi (Ustanovit' Jitsi) [Y/N]?"
    read q_jitsi
    
    echo "Установить NBICS (Ustanovit' NBICS) [Y/N]?"
    read q_nbics
    
    echo "==================================="
    echo "Настройка сети  (Nastrojka seti)  - " $q_netconf
    echo "Установка Jitsi (Ustanovka Jitsi) - " $q_jitsi
    echo "Установка NBICS (Ustanovka NBICS) - " $q_nbics
    
    echo "==================================="
    echo "                                   "
    echo "Всё правильно (Vsyo pravil'no) [Y/N]?"
    read q_check
    
    if [[ $q_check = Y ]]
    then
        break
    fi    
done

# Чистим промежуточный файл delta.sh и вписываем первую строчку
echo -n > ./autonbics/scripts/delta.sh
echo '#!/bin/bash' >> ./autonbics/scripts/delta.sh

# Функции для заполнения опросника questions.txt
# В опроснике - заготовленные ответы для настройки программ
function set_netconf() {

}

function set_jitsi() {

}

function set_nbics() {

}

# Три ветви для запонения delta.sh и вызова нужных функций
# delta.sh заполняется вызовами выбранных скриптов
if [[ $q_netconf = Y ]]
then
    set_netconf()
    echo 'source ./autonbics/scripts/netconf.sh' >> ./autonbics/scripts/delta.sh    
fi

if [[ $q_jitsi = Y ]]
then
    set_jitsi()
    echo 'source ./autonbics/scripts/jitsi_inst.sh' >> ./autonbics/scripts/delta.sh    
fi

if [[ $q_nbics = Y ]]
then
    set_nbics()
    echo 'source ./autonbics/scripts/nbics_inst.sh' >> ./autonbics/scripts/delta.sh    
fi

# Вызов delta.sh, который запускает нужную конфигурацию установки программ
source ./autonbics/scripts/delta.sh

echo "Тестовый выход из цикла"

