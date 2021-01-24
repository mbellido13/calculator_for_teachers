#!/bin/bash

# Preguntamos si el usuario ha usado anteriormente el script.
comprobador_de_existencia(){
  clear
  read -p "Es la primera vez que utilizas el programa S/N?" existe
  case $existe in
    [Ss]* ) comprobador_de_acuerdo;; #funcion que creara toda la estructura
    [Nn]* ) tienes_cuenta;;#funcion para continuar
  esac
}
# Pedirá al usuario si esta de acuerdo con que la estructuras de carpetas
# se cree en el directorio actual
comprobador_de_acuerdo(){
  clear
  read -p "El arbol de carpetas se creara dentro del directorio actual, estas de acuerdo S/N?" arbol_de_carpetas
  case $arbol_de_carpetas in
    [Ss]* ) creador_de_la_estructura;;
    [Nn]* ) exit;;
  esac
}

# Creara la estructura de carpetas
creador_de_la_estructura (){
  mkdir ADYUP
  mkdir ADYUP/DATABASE
  touch ADYUP/DATABASE/database.txt
  mkdir ADYUP/PROFESORES
  mkdir ADYUP/PROFESORES/CURSOS
  mkdir ADYUP/PROFESORES/CLASES
}

# Comprobaremos si tienen usuario = login, si no tienen usuario = registro
log_in(){
  echo "¿Cual es tu nombre de usuario?"
  read nombre_usuario
  echo "Ingresa tu contraeña"
  read contrasena_usuario
  # buscara el nombre de usuario y su contraseña para Comprobaremos
  contrasena_database=`cat ADYUP/DATABASE/database.txt | grep $nombre_usuario | cut -d ":" -f4`
  echo contrasena_database
  # comprobamos si la contrseña introducida coincide con la base de datos
  if [[ $contrasena_database = $contrasena_usuario ]]; then
    clear
    echo "Bienvenido $nombre_usuario!!!"
    # AQUI IRA LA FUNCIÓN PARA SEGUIR EL SCRIPT
  else
    clear
    echo "Los datos introducidos no son validos!!!"
    sleep 2
    # vuelve otra vez al login inicial
    log_in
  fi
}

# comprobara si el usuario tiene cuenta  o no para ir a login o a registro
tienes_cuenta(){
  clear
  read -p "Tienes una cuenta S/N?" existe_cuenta
  case $existe_cuenta in
    [Ss]* ) log_in;; #el usuario se logea
    [Nn]* ) crear_usuario;;#crea la cuenta del usuario
  esac
}

# comprobamos si el nombre del usuario ya existe en la base de DATOS, mediante si la variable esta vacia o no
existe_ya_el_usuario(){
  echo "Añade un nombre de usuario"
  read nombre_usuario_nuevo
  existencia_del_usuario=`cat ADYUP/DATABASE/database.txt | cut -d ":" -f3 | grep $nombre_usuario_nuevo`
  if [[ "$existencia_del_usuario" ]]; then
      echo "El nombre de usuario introducido no es validos
              (ya existe en la base de datos)"
    # si el usuario existe volvemos a la funcion que pide el nomrbe de usuario y lo comprueba
    existe_ya_el_usuario
    else
      echo "El nombre de usuario introducido es valido"
  fi

}

# funcion para crear un nuevo usuario, bien sea profesor o alumno
crear_usuario(){
  clear
  # cuando sea usuario valor 0, cuando sea profesor valor 1, se utilizara para diferenciar el tipo de cuenta
  read -p "Eres profesor o alumno P/A?" tipo_de_cuenta
  if [[ $tipo_de_cuenta = "P" ]]; then
    tipo_de_cuenta_completa="1";
  else
    tipo_de_cuenta_completa="0";
  fi
  # llamamos a la funcion para comprobar si el usuario existe o no
  existe_ya_el_usuario
  # creamos un nuevo id a partir de los usuarios creados
  numero_de_usuarios=`cat ADYUP/DATABASE/database.txt | cut -d ":" -f1 | sort -n | tail -1`
  id=$[ $numero_de_usuarios + 1 ]

  # Pedimos el nombre real y los apellidos
  echo "Inserta una contraseña"
  read contrasena
  echo "Inserta tu nombre"
  read nombre_real
  echo "Inserta tus apellidos"
  read apellidos_real

    # escribiremos el siguiente contenido en la base de datos
  echo "$id:$tipo_de_cuenta_completa:$nombre_usuario_nuevo:$contrasena:$nombre_real:$apellidos_real" >> ADYUP/DATABASE/database.txt
}

# FUNCION INCIO, la creamos al final ya que sera utilizada como ejecutador del programa
inicio(){
  clear
  comprobador_de_existencia
}

# inicio funcionara como el lanzador del programa
inicio
