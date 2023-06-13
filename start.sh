#!/bin/bash

# Переменные для конфигурирования установки
q_netconf=Y
q_jitsi=Y
q_nbics=Y
q_check=Y

# Переменные для опросника
netconfIpMask=A
netconfGateway=A
netconfDns=A

jitsiNameDomain=A
jitsiCertificate=A
jitsiEmail=A
jitsiJaas=A
jitsiEmailCertbot=A
jitsiLoginOrganizer=A
jitsiPasswordOrganizer=A

nbicsNameDomain=A
nbicsNameDataBase=A
nbicsPasswordDataBase=A

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

# Удаление ранее введённых данных (если были) из файла questions.txt
echo -n > ./autonbics/questions.txt
cp ./autonbics/files/template_questions.txt ./autonbics/questions.txt

# Проверка файла с настройками (если не пустой - предложить показать их)
checkFileWithPreset=$(wc -m ./autonbics/files/preset_questions.txt | grep -o '[0-9]*')
questPreset=Y
if [[ $checkFileWithPreset > 700 ]]
then
    echo "У вас сохранены предыдущие настройки. Показать их? [Y/N]"
    echo "U vas sohraneny predydushchie nastrojki. Pokazat' ih? [Y/N]"
    read questPreset
    if [[ $questPreset = Y ]]
    then
        echo "==========================================="
        cat ./autonbics/files/preset_questions.txt
        echo "==========================================="
        echo "==========================================="
    fi
fi

# Функции для заполнения опросника questions.txt
# В опроснике - заготовленные ответы для настройки программ
function setNetconf() {
    # Присваиваем переменным в качестве значений данные для настроек
    echo "-------------------------------------------"
    echo "Настраиваем сеть (Nastraivaem set'):"
    echo "-------------------------------------------"
    read -p "IP-адрес/Маска (IP-adres/Maska): " netconfIpMask
    read -p "Шлюз (Shlyuz): " netconfGateway
    read -p "Серверы DNS (Servery DNS): " netconfDns
    echo "==========================================="
    
    # Эти данные для настроек потом вписываются в файл questions.txt
    sed -i -e "s|1. IP-адрес/маска......... |1. IP-адрес/маска......... $netconfIpMask|g" ./autonbics/questions.txt
    sed -i -e "s|2. Шлюз................... |2. Шлюз................... $netconfGateway|g" ./autonbics/questions.txt
    sed -i -e "s|3. Серверы ДНС............ |3. Серверы ДНС............ $netconfDns|g" ./autonbics/questions.txt    
}

function setJitsi() {
    echo "-------------------------------------------"
    echo "Настраиваем Jitsi (Nastraivaem Jitsi):"
    echo "-------------------------------------------"
    read -p "Доменное имя (Domennoe imya): " jitsiNameDomain
    read -p "Сертификат через Let’s Encrypt (Sertifikat cherez Let’s Encrypt) [Y/N]: " jitsiCertificate
    read -p "E-mail для Let’s Encrypt (E-mail dlya Let’s Encrypt): " jitsiEmail
    # read -p "Добавить поддержку телефонии (Dobavit' podderzhku telefonii) [Y/N]: " jitsiJaas
    # read -p "..........: " jitsiEmailCertbot
    read -p "Логин организатора конференции (Login organizatora konferencii): " jitsiLoginOrganizer
    read -p "Пароль организатора конференции (Parol' organizatora konferencii): " jitsiPasswordOrganizer
    echo "==========================================="
    
    sed -i -e "s|1. Имя домена Jitsi....... |1. Имя домена Jitsi....... $jitsiNameDomain|g" ./autonbics/questions.txt
    sed -i -e "s|2. Сертификат............. |2. Сертификат............. $jitsiCertificate|g" ./autonbics/questions.txt
    sed -i -e "s|3. Эл. почта.............. |3. Эл. почта.............. $jitsiEmail|g" ./autonbics/questions.txt
    sed -i -e "s|6. Логин организатора..... |6. Логин организатора..... $jitsiLoginOrganizer|g" ./autonbics/questions.txt
    sed -i -e "s|7. Пароль организатора.... |7. Пароль организатора.... $jitsiPasswordOrganizer|g" ./autonbics/questions.txt
}

function setNbics() {
    echo "-------------------------------------------"
    echo "Настраиваем NBICS (Nastraivaem NBICS):"
    echo "-------------------------------------------"
    read -p "Доменное имя (Domennoe imya): " nbicsNameDomain
    read -p "Имя базы данных (Imya bazy dannyh): " nbicsNameDataBase
    read -p "Пароль администратора базы данных (Parol' administratora bazy dannyh): " nbicsPasswordDataBase
    echo "==========================================="
    
    sed -i -e "s|1. Имя домена NBICS....... |1. Имя домена NBICS....... $nbicsNameDomain|g" ./autonbics/questions.txt
    sed -i -e "s|2. Имя базы данных........ |2. Имя базы данных........ $nbicsNameDataBase|g" ./autonbics/questions.txt
    sed -i -e "s|3. Пароль базы данных..... |3. Пароль базы данных..... $nbicsPasswordDataBase|g" ./autonbics/questions.txt
}

# Три ветви для запонения delta.sh и вызова нужных функций
# delta.sh заполняется вызовами выбранных скриптов
if [[ $q_netconf = Y ]]
then
    setNetconf
    echo 'source ./autonbics/scripts/netconf.sh' >> ./autonbics/scripts/delta.sh    
fi

if [[ $q_jitsi = Y ]]
then
    setJitsi
    echo 'source ./autonbics/scripts/jitsi_inst.sh' >> ./autonbics/scripts/delta.sh    
fi

if [[ $q_nbics = Y ]]
then
    setNbics
    echo 'source ./autonbics/scripts/nbics_inst.sh' >> ./autonbics/scripts/delta.sh    
fi

# Копирование введённых данных в файл preset_questions.txt
echo -n > ./autonbics/files/preset_questions.txt
cp ./autonbics/questions.txt ./autonbics/files/preset_questions.txt

# Устанавливаем необходимые общие утилиты
apt-get -y -q install curl
apt-get -y -q install debconf-utils
apt-get -y -q install apt-transport-https

# Вызов delta.sh, который запускает нужную конфигурацию установки программ
source ./autonbics/scripts/delta.sh

echo "Тестовый выход из цикла"

