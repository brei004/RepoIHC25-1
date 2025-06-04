# Speech-to-Text Assistant Flutter App (Pluma ai)

Este proyecto es una aplicación Flutter que permite reconocer voz en español, resaltar palabras clave en la transcripción y enviar el texto reconocido a un modelo LLM (Large Language Model) para obtener respuestas breves que ayuden a mejorar ideas y textos. También cambia el fondo según palabras detectadas y utiliza vibración para alertas.

---

## Características

- Reconocimiento de voz en español (`es_ES`) con feedback en tiempo real.
- Resaltado de palabras clave con colores y estilos específicos.
- Cambio dinámico de fondo según palabras positivas o negativas detectadas.
- Vibración en caso de detectar palabras negativas.
- Envío del texto reconocido a un LLM vía API para obtener respuestas de asistencia.
- Guardado de historial de prompts y respuestas.
- Interfaz simple con botón flotante animado para activar/desactivar el micrófono.

---

## Tecnologías y paquetes usados

- Flutter
- [speech_to_text](https://pub.dev/packages/speech_to_text) - Reconocimiento de voz.
- [highlight_text](https://pub.dev/packages/highlight_text) - Para el resaltado de palabras en el texto.
- [avatar_glow](https://pub.dev/packages/avatar_glow) - Animación alrededor del botón de micrófono.
- [vibration](https://pub.dev/packages/vibration) - Control de vibración para alertas.
- [http](https://pub.dev/packages/http) - Para las llamadas a la API del modelo LLM.
- Manejo personalizado de historial mediante `HistoryService` (servicio propio).

---

## Estructura principal

- `SpeechScreen` (StatefulWidget): Pantalla principal que gestiona el reconocimiento de voz, resaltado, estado y llamadas a la API.
- `_listen()` método: Inicia/detiene la escucha y cambia el color de fondo según el texto detectado.
- `_enviarTextoAlLLM()`: Envía texto a la API del modelo LLM y maneja la respuesta.
- Mapa `_highlights`: Define las palabras resaltadas y sus estilos.
- Listas `_palabrasNegativas` y `_palabrasPositivas`: Usadas para detectar sentimiento en el texto.

---

## Cómo usar

1. Clonar el repositorio.
2. Asegurarse de tener Flutter instalado y configurado.
3. Ejecutar `flutter pub get` para instalar las dependencias.
4. Reemplazar la clave de API en `_enviarTextoAlLLM()` con tu propia clave válida.
5. Ejecutar en un dispositivo o emulador con micrófono y soporte para reconocimiento de voz.

---

## Ejemplo de uso

- Presiona el botón del micrófono para comenzar a hablar.
- La aplicación transcribirá en tiempo real y resaltará palabras clave.
- Si la transcripción contiene palabras negativas, la pantalla se pondrá roja y vibrará.
- Si contiene palabras positivas, se pondrá verde.
- Puedes enviar el texto al asistente LLM con el botón "Enviar a LLM" para obtener ayuda en tus ideas o textos.
- Verás la respuesta generada en la pantalla.

---

## Notas

- La vibración puede no funcionar en todos los dispositivos/emuladores.
- Asegúrate de manejar la clave API de forma segura, evitando exponerla en repositorios públicos.
- La lista de palabras positivas/negativas se puede ampliar para mejor detección.
- El modelo LLM utilizado puede cambiar según la API y las configuraciones de tu cuenta.

---

## Licencia

Este proyecto es de código abierto y libre para usar y modificar.


