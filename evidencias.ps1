chcp 65001 | Out-Null

function check_folder { # Comprobamos que la carpeta es válida (existe)

    while($true){

        Set-Variable -Name "directorio" -Value "$(Write-Host "`nInserte la ruta en la que se guardará los informes:  " -NoNewLine -ForegroundColor DarkGreen )$(Read-Host)" -Scope Global

        if(Test-Path -Path "$directorio" -PathType Container){
            break
        }else{
            Write-Host "ERROR. " -ForegroundColor red -NoNewLine; Write-Host "Lo que has introducido" -ForeGroundColor yellow -NoNewLine; Write-Host " ($directorio) " -ForeGroundColor cyan -NoNewline; Write-Host "NO es una carpeta" -ForeGroundColor yellow
    }}
}

function make_folder {
    param (
        [Parameter(Mandatory=$true)]
        [string]$nuevo_directorio
    )
    if(-not (Test-Path -Path "$directorio\$nuevo_directorio" -PathType Container)){
        New-Item -ItemType Directory -Path "$directorio\$nuevo_directorio" | Out-Null
    }
   
}

function programador_tareas{
    schtasks | Set-Content -Path "$directorio\Procesos\TareasProgramadas.txt" -Encoding unicode
    # schtasks | Out-File -FilePath "$directorio\Procesos\TareasProgramadas.txt" -Encoding utf8
    
    if(Test-Path "$directorio\Procesos\TareasProgramadas.txt") {
        Write-Host "El archivo del Tareas Programadas se creó correctamente en '$directorio\Procesos\TareasProgramadas.txt'" -ForegroundColor Gray
    }else{
        Write-Host "ERROR. " -ForegroundColor red -NoNewLine; Write-Host "El histórico de Tareas Programadas falló." -ForeGroundColor yellow
    }
}

function historico {
    Get-History | Format-List -Property * | Out-File -FilePath "$directorio\historial_powershell.txt" -Encoding unicode

    if(Test-Path "$directorio\HistorialPowershell.txt") {
        Write-Host "El archivo del historial de comandos se creó correctamente en '$directorio\historial_powershell.txt" -ForegroundColor Gray
    }else{
        Write-Host "ERROR. " -ForegroundColor red -NoNewLine; Write-Host "El histórico de comandos falló." -ForeGroundColor yellow
    }
}

function mapeadas {

    Get-PSDrive  | Out-File -FilePath "$directorio\UnidadesMapeadas.txt"

    if(Test-Path "$directorio\UnidadesMapeadas.txt") {
        Write-Host "Las unidades mapeadas se creó correctamente en '$directorio\UnidadesMapeadas.txt'" -ForegroundColor Gray
    }else{
        Write-Host "ERROR. " -ForegroundColor red -NoNewLine; Write-Host "Las unidades mapeadas falló." -ForeGroundColor yellow 
    }
}

function compartido {

    Get-SmbShare  | Out-File -FilePath "$directorio\CarpetasCompartidas.txt"

    if(Test-Path "$directorio\CarpetasCompartidas.txt") {
        Write-Host "Las carpetas compartidas se creó correctamente en '$directorio\CarpetasCompartidas.txt'" -ForegroundColor Gray
    }else{
        Write-Host "ERROR. " -ForegroundColor red -NoNewLine; Write-Host "Las unidades mapeadas falló." -ForeGroundColor yellow
    }
}


function procesos {

    Get-Process | Select-Object -Property * | Out-File -FilePath "$directorio\Procesos\ProcesosEnEjecucion.txt" -Encoding unicode

    if(Test-Path "$directorio\Procesos\ProcesosEnEjecucion.txt") {
        Write-Host "Los procesos en ejecución se creó correctamente en '$directorio\Procesos\ProcesosEnEjecucion.txt'" -ForegroundColor Gray
    }else{
        Write-Host "ERROR. " -ForegroundColor red -NoNewLine; Write-Host "Las unidades mapeadas falló." -ForeGroundColor yellow
    }
}


function usuarios{
    $users = Get-LocalUser 
    $users | Out-File -FilePath "$directorio\Usuarios\usuarios_totales.txt"
    foreach ($user in $users) {
        net user $user.name | Out-File -FilePath "$directorio\Usuarios\usuarios.txt" -Encoding unicode -Append
        Add-Content -Path "$directorio\Usuarios\usuarios.txt" -Value "----------------------------------------------------------------`n`n"
    }
}

function servicios {
    sc.exe query | Out-File -FilePath "$directorio\ServiciosEnEjecucion.txt"

    if(Test-Path "$directorio\ServiciosEnEjecucion.txt") {
        Write-Host "Los servicios en ejecución se creó correctamente en '$directorio\ServiciosEnEjecucion.txt'" -ForegroundColor Gray
    }else{
        Write-Host "ERROR. " -ForegroundColor red -NoNewLine; Write-Host "Las unidades mapeadas falló." -ForeGroundColor yellow -NoNewLine
    }

}

function red{
    Get-NetNeighbor -State Reachable | Get-NetAdapter | Out-File -FilePath "$directorio\Red\Adaptadores-Recien-Usados.txt"
    Get-NetAdapter | Out-File -FilePath "$directorio\Red\Adaptadores-Red.txt"
    arp -a | Out-File -FilePath "$directorio\Red\ARP.txt"
    Get-DnsClientCache | Out-File -FilePath "$directorio\Red\Cache-DNS.txt"
    net sessions | Out-File -FilePath "$directorio\Red\SesionesRemotasEstablecidas.txt"
    netstat -an | Out-File -FilePath "$directorio\Red\ConexionesActivas.txt"
    netstat -anob | Out-File -FilePath "$directorio\Red\AplicacionesPuertosAbiertos.txt"
    ipconfig /all | Out-File -FilePath "$directorio\Red\EstadoDeLaRed.txt"
}


while ($true) { # Bucle infinito para sacar donde se va a guardar la copia, si no existe el directorio, se le preguntará si se quiere crear o no.

    Write-Output "`n`n`nLa fecha actual es: $(Get-date -uformat '%A, %d\%m\%Y %T UTC%Z')`n"

    Write-Host "1" -ForegroundColor Magenta -NoNewLine ; Write-Host ") " -ForegroundColor White -NoNewLine; Write-Host "Todo" -ForegroundColor Green
    Write-Host "2" -ForegroundColor Magenta -NoNewLine ; Write-Host ") " -ForegroundColor White -NoNewLine; Write-Host "Revisar conexiones" -ForegroundColor Green
    Write-Host "3" -ForegroundColor Magenta -NoNewLine ; Write-Host ") " -ForegroundColor White -NoNewLine; Write-Host "Usuarios conectados y listado de usuarios" -ForegroundColor Green
    Write-Host "4" -ForegroundColor Magenta -NoNewLine ; Write-Host ") " -ForegroundColor White -NoNewLine; Write-Host "Adquisición de procesos" -ForegroundColor Green
    Write-Host "5" -ForegroundColor Magenta -NoNewLine ; Write-Host ") " -ForegroundColor White -NoNewLine; Write-Host "Adquisición de servicios" -ForegroundColor Green
    Write-Host "6" -ForegroundColor Magenta -NoNewLine ; Write-Host ") " -ForegroundColor White -NoNewLine; Write-Host "Tareas programadas" -ForegroundColor Green
    Write-Host "7" -ForegroundColor Magenta -NoNewLine ; Write-Host ") " -ForegroundColor White -NoNewLine; Write-Host "Histórico de comandos" -ForegroundColor Green
    Write-Host "8" -ForegroundColor Magenta -NoNewLine ; Write-Host ") " -ForegroundColor White -NoNewLine; Write-Host "Unidades mapeadas" -ForegroundColor Green
    Write-Host "9" -ForegroundColor Magenta -NoNewLine ; Write-Host ") " -ForegroundColor White -NoNewLine; Write-Host "Carpetas compartidas" -ForegroundColor Green
    Write-Host "10" -ForegroundColor Magenta -NoNewLine ; Write-Host ") " -ForegroundColor White -NoNewLine; Write-Host "Salir`n" -ForegroundColor Green
    
    $respuesta = $(Write-Host "Introduce la opción que necesites. Tiene que ser el número o el texto del menú:  " -NoNewLine -ForegroundColor yellow) + 
    $(Read-Host)
    
    switch -CaseSensitive ($respuesta){

        {($_ -eq 1) -or ($_ -eq "Todo")}{
            check_folder
            Get-date -uformat '%A, %d\%m\%Y %T UTC%Z' | Out-File -FilePath "$directorio\Fecha.txt"
            make_folder "Red"
            make_folder "Usuarios"
            make_folder "Procesos"
            red
            usuarios
            procesos
            servicios
            programador_tareas
            historico
            mapeadas
            compartido
        }

        {($_ -eq 2) -or ($_ -eq "Red")}{
            check_folder
            make_folder "Red"
            Get-date -uformat '%A, %d\%m\%Y %T UTC%Z' | Out-File -FilePath "$directorio\Fecha.txt"
            red
        }

        {($_ -eq 3) -or ($_ -eq "Usuarios conectados y listado de usuarios")}{
            check_folder
            make_folder "Usuarios"
            Get-date -uformat '%A, %d\%m\%Y %T UTC%Z' | Out-File -FilePath "$directorio\Fecha.txt"
            usuarios
        }

        {($_ -eq 4) -or ($_ -eq "Adquisición de procesos")}{
            check_folder
            make_folder "Procesos"
            Get-date -uformat '%A, %d\%m\%Y %T UTC%Z' | Out-File -FilePath "$directorio\Fecha.txt"
            procesos
        }

        {($_ -eq 5) -or ($_ -eq "Adquisición de servicios")}{
            check_folder
            Get-date -uformat '%A, %d\%m\%Y %T UTC%Z' | Out-File -FilePath "$directorio\Fecha.txt"
            servicios
        }

        {($_ -eq 6) -or ($_ -eq "Tareas programadas")}{
            check_folder
            make_folder "Procesos"
            Get-date -uformat '%A, %d\%m\%Y %T UTC%Z' | Out-File -FilePath "$directorio\Fecha.txt"
            programador_tareas
        }

        {($_ -eq 7) -or ($_ -eq "Histórico de comandos")}{
            check_folder
            Get-date -uformat '%A, %d\%m\%Y %T UTC%Z' | Out-File -FilePath "$directorio\Fecha.txt"
            historico
        }

        {($_ -eq 8) -or ($_ -eq "Unidades mapeadas")}{
            check_folder
            Get-date -uformat '%A, %d\%m\%Y %T UTC%Z' | Out-File -FilePath "$directorio\Fecha.txt"
            mapeadas
        }

        {($_ -eq 9) -or ($_ -eq "Carpetas compartidas")}{
            check_folder
            Get-date -uformat '%A, %d\%m\%Y %T UTC%Z' | Out-File -FilePath "$directorio\Fecha.txt"
            compartido
        }

        {($_ -eq 10) -or ($_ -eq "Salir")}{
            Write-Host "`nSaliendo del script...`n`n" -ForegroundColor White
            exit 0
        }

        default { Write-Host "Debes introducir un numero del 1 al 11 o el texto del menu" -ForeGroundColor red} 
    }
}