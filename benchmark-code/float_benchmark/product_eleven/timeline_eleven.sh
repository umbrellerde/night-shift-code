# Warm Start ca. 20s nach einem Funktionsaufruf
# die Zeit im Skript und in Funktionen (FunctionBench) wird in Sekunden gemessen

# logs sollten in eine Textdatei geschrieben werden -> log_google.txt
# ansonsten wird die Datei mysqldata.txt an SQL Schnittstelle übergeben
# am Ende wird die mysqldata.txt Datei durch safe.txt ersetzt

variablen () {
    invoke_eleven=$(date '+%s.%N') # überall im Skript durch date +%s.%N
    (curl -X POST -H "Content-Type:application/json" -H "Authorization: bearer $(gcloud auth print-identity-token)" https://europe-west1-intrepid-tape-368615.cloudfunctions.net/float_big_eleven_$i -d '{"N": 15000}')> result.txt
    return_eleven=$(date '+%s.%N')
        
    id_eleven=$(sed -n 1p result.txt) # hier wird die execution-id, aus der Funktionsrückgabe gefiltert
    start_eleven=$(sed -n 2p result.txt)
    stop_eleven=$(sed -n 3p result.txt)
    realtype_eleven=$(sed -n 4p result.txt)
         
    # außer den Log Daten werden alle Dateien in die Textdatei geschrieben
    # results müssen @start_w, @stop_w / @start_c, @stop_c benannt werden in myqldata.txt
    sed -i "1 i\SET @invoke_$type_eleven := $invoke_eleven;" mysqldata.txt
    sed -i "1 i\SET @return_$type_eleven := $return_eleven;" mysqldata.txt   
    sed -i "1 i\SET @start_$type_eleven := $start_eleven;" mysqldata.txt  
    sed -i "1 i\SET @stop_$type_eleven := $stop_eleven;" mysqldata.txt
    sed -i "1 i\SET @id_$type_eleven := '$id_eleven';" mysqldata.txt
    # Boolean, der angibt ob es wirklich ein Cold start wat
    sed -i "1 i\SET @cold_$type_eleven := '$realtype_eleven';" mysqldata.txt

    # die Logs brauchen ein paar Sekunden, um für den Funktionsaufruf erstellt zu werden
    sleep 20
    gcloud functions logs read float_big_eleven_$i --execution-id $id_eleven > log_google.txt
    if [ -s log_google.txt ]
    then
        execution_eleven=$(grep -o "took\(.*\)ms" log_google.txt)  
        # Die Log - Daten werden im richtigen Fomat in die Text Datei geschrieben
        sed -i "1 i\SET @log_executiontime_$type_eleven := $execution_eleven;" mysqldata.txt
    fi 
}

while true
do 
    for i in {1..7}; do
        # die Funktion wird aufgerufen -> geplant Cold_start
        (type_eleven="c"
        variablen
        # die Funktion wird aufgerufen -> geplant Warm_Start
        type_eleven="w"
        variablen
        sed -i "s/took //g" mysqldata.txt
        sed -i "s/ ms//g" mysqldata.txt
        # Datei wird in der gcloud geladen, und danach mit einer Sicherheitskopie wieder überschrieben
        (mysql -h 34.140.10.130 --user=root --password='WtfGooglePwd?') < mysqldata.txt
        cp -f safe.txt mysqldata.txt)&
        sleep 200
    done
done