# Virtual Course - iOS

Este repositorio contiene un proyecto desarrollado en lenguaje Swift, utilizando el patrón de diseño MVC, servirá para que alumnos de diferentes instituciones puedan llevar de una manera más sencilla la organización de sus cursos virtuales, además se puede usar como una herramientas de enseñanza para futuros cursos de Swift.

## Integrantes

- Cabrera Garibaldi Hernán Galileo
  - Github: https://github.com/galigaribaldi
- Flores Martínez Emanuel
  - Github: https://github.com/e-muf

## Problemática

Se desea crear una aplicación donde se puedan guardar la descripción de las clases online, esto para tener un mayor control sobre las mismas, la aplicaicón tiene que guardar los siguiente datos:

- Nombre del curso
- Link de Clase
- Horario
- Descripción

Así mismo se recomienda tener un login de usuarios para poder tene run mayor control sobre el mismo. en el login se desean guardar los siguientes datos:

- Correo
- Contraseña
- Nombre de usuario

Estos datos deben ser perecederos, por lo que se recomienda usar un gestor de base de datos.

## Implementación

En este caso se optó por usar como gestor de base de datos **FireBase**. Usando una colección llamada *users* en la cual se almacena los siguientes datos:

- Nombre del usuario: **Tipo de dato String**
- Correo: **Tipo de dato String**
- Contraseña: **Tipo de dato String**

Por otro lado se usa una segunda colección llamada *courses*, en la cual se guarda la información de los cursos, esta colección se describe aocntinuación

- Nombre del curso: **Tipo de dato String**
- Link de la clase: **Tipo de dato String**
- Horario: **Tipo de dato String**
- Descripción: **Tipo de dato String**
- Link de la imágen: **Tipo de dato URL**

El guardado de la imagen se hace con ayuda de *firestore*, esto creando una carpeta llamada *images*, en la cual se almacena la imagen perce, es decir que la imagen se guarda en este directorio y después se reotran el *URL*, de la imagen que genera firebase para meterla en la colección anteriormente mencionada.

### Video
Se puede ver un video del funcionamiento en el siguiente enlace: https://youtu.be/srrzsx7K5pE
