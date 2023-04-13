# Warm Start ca. 20s nach einem Funktionsaufruf
# die Zeit im Skript und in Funktionen (FunctionBench) wird in Sekunden gemessen

# logs sollten in eine Textdatei geschrieben werden -> log_google.txt
# ansonsten wird die Datei mysqldata.txt an SQL Schnittstelle übergeben
# am Ende wird die mysqldata.txt Datei durch safe.txt ersetzt

variablen () {
    invoke_ten=$(date '+%s.%N') # überall im Skript durch date +%s.%N
    (curl -X POST -H "Content-Type:application/json" -H "Authorization: bearer $(gcloud auth print-identity-token)" https://europe-west1-intrepid-tape-368615.cloudfunctions.net/float_middle_ten_$i -d '{"N": 15000}')> result.txt
    return_ten=$(date '+%s.%N')
        
    id_ten=$(sed -n 1p result.txt) # hier wird die execution-id, aus der Funktionsrückgabe gefiltert
    start_ten=$(sed -n 2p result.txt)
    stop_ten=$(sed -n 3p result.txt)
    realtype_ten=$(sed -n 4p result.txt)
         
    # außer den Log Daten werden alle Dateien in die Textdatei geschrieben
    # results müssen @start_w, @stop_w / @start_c, @stop_c benannt werden in myqldata.txt
    sed -i "1 i\SET @invoke_$type_ten := $invoke_ten;" mysqldata.txt
    sed -i "1 i\SET @return_$type_ten := $return_ten;" mysqldata.txt   
    sed -i "1 i\SET @start_$type_ten := $start_ten;" mysqldata.txt  
    sed -i "1 i\SET @stop_$type_ten := $stop_ten;" mysqldata.txt
    sed -i "1 i\SET @id_$type_ten := '$id_ten';" mysqldata.txt
    # Boolean, der angibt ob es wirklich ein Cold start wat
    sed -i "1 i\SET @cold_$type_ten := '$realtype_ten';" mysqldata.txt

    # die Logs brauchen ein paar Sekunden, um für den Funktionsaufruf erstellt zu werden
    sleep 20
    gcloud functions logs read float_middle_ten_$i --execution-id $id_ten > log_google.txt
    if [ -s log_google.txt ]
    then
        execution_ten=$(grep -o "took\(.*\)ms" log_google.txt)  
        # Die Log - Daten werden im richtigen Fomat in die Text Datei geschrieben
        sed -i "1 i\SET @log_executiontime_$type_ten := $execution_ten;" mysqldata.txt
    fi 
}

while true
do 
    for i in {1..7}; do
        # die Funktion wird aufgerufen -> geplant Cold_start
        (type_ten="c"
        variablen
        # die Funktion wird aufgerufen -> geplant Warm_Start
        type_ten="w"
        variablen
        sed -i "s/took //g" mysqldata.txt
        sed -i "s/ ms//g" mysqldata.txt
        # Datei wird in der gcloud geladen, und danach mit einer Sicherheitskopie wieder überschrieben
        (mysql -h 34.140.10.130 --user=root --password='WtfGooglePwd?') < mysqldata.txt
        cp -f safe.txt mysqldata.txt)&
        sleep 200
    done
done