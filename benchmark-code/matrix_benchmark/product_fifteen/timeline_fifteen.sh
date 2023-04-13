# Warm Start ca. 20s nach einem Funktionsaufruf
# die Zeit im Skript und in Funktionen (FunctionBench) wird in Sekunden gemessen

# logs sollten in eine Textdatei geschrieben werden -> log_google.txt
# ansonsten wird die Datei mysqldata.txt an SQL Schnittstelle übergeben
# am Ende wird die mysqldata.txt Datei durch safe.txt ersetzt

variablen () {
    invoke_fifteen=$(date '+%s.%N') # überall im Skript durch date +%s.%N
    (curl -X POST -H "Content-Type:application/json" -H "Authorization: bearer $(gcloud auth print-identity-token)" https://europe-west1-intrepid-tape-368615.cloudfunctions.net/matrixmult_big_fifteen_$i -d '{"A": [[1,5,2],[3,4,5],[2,3,4]], "B": [[6,5,2],[3,9,5],[7,3,7]]}')> result.txt
    return_fifteen=$(date '+%s.%N')
        
    id_fifteen=$(sed -n 1p result.txt) # hier wird die execution-id, aus der Funktionsrückgabe gefiltert
    start_fifteen=$(sed -n 2p result.txt)
    stop_fifteen=$(sed -n 3p result.txt)
    realtype_fifteen=$(sed -n 4p result.txt)
         
    # außer den Log Daten werden alle Dateien in die Textdatei geschrieben
    # results müssen @start_w, @stop_w / @start_c, @stop_c benannt werden in myqldata.txt
    sed -i "1 i\SET @invoke_$type_fifteen := $invoke_fifteen;" mysqldata.txt
    sed -i "1 i\SET @return_$type_fifteen := $return_fifteen;" mysqldata.txt   
    sed -i "1 i\SET @start_$type_fifteen := $start_fifteen;" mysqldata.txt  
    sed -i "1 i\SET @stop_$type_fifteen := $stop_fifteen;" mysqldata.txt
    sed -i "1 i\SET @id_$type_fifteen := '$id_fifteen';" mysqldata.txt
    # Boolean, der angibt ob es wirklich ein Cold start wat
    sed -i "1 i\SET @cold_$type_fifteen := '$realtype_fifteen';" mysqldata.txt

    # die Logs brauchen ein paar Sekunden, um für den Funktionsaufruf erstellt zu werden
    sleep 20
    gcloud functions logs read matrixmult_big_fifteen_$i --execution-id $id_fifteen > log_google.txt
    if [ -s log_google.txt ]
    then
        execution_fifteen=$(grep -o "took\(.*\)ms" log_google.txt)  
        # Die Log - Daten werden im richtigen Fomat in die Text Datei geschrieben
        sed -i "1 i\SET @log_executiontime_$type_fifteen := $execution_fifteen;" mysqldata.txt
    fi 
}

while true
do 
    for i in {1..7}; do
        # die Funktion wird aufgerufen -> geplant Cold_start
        (type_fifteen="c"
        variablen
        # die Funktion wird aufgerufen -> geplant Warm_Start
        type_fifteen="w"
        variablen
        sed -i "s/took //g" mysqldata.txt
        sed -i "s/ ms//g" mysqldata.txt
        # Datei wird in der gcloud geladen, und danach mit einer Sicherheitskopie wieder überschrieben
        (mysql -h 34.140.10.130 --user=root --password='WtfGooglePwd?') < mysqldata.txt
        cp -f safe.txt mysqldata.txt)&
        sleep 200
    done
done