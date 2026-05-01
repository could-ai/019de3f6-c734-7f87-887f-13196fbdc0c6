# Detector de Texto IA

Una aplicación en Flutter que analiza textos para determinar la probabilidad de que hayan sido generados por una Inteligencia Artificial (como ChatGPT, Claude, Gemini, etc.) o si fueron escritos por un ser humano.

## Características

* **Interfaz Moderna y Limpia**: Un diseño intuitivo que permite pegar o escribir textos de forma sencilla.
* **Análisis Simulado Inteligente**: Utiliza métricas base como *Perplejidad* (previsibilidad de las palabras) y *Ráfagas* (variabilidad en la longitud y estructura de las oraciones) para calcular un puntaje de probabilidad.
* **Resultados Visuales**: Indicadores circulares y codificación por colores (rojo para IA, verde para humano) para una lectura rápida del resultado.
* **Soporte para Modo Oscuro/Claro**: Se adapta automáticamente al tema del sistema del usuario.

## Flujo de Usuario Principal

1. El usuario abre la aplicación y se encuentra con un campo de texto amplio.
2. Pega un artículo, ensayo o párrafo en el cuadro de texto.
3. Presiona el botón **Analizar Texto**.
4. La aplicación procesa el texto, simulando una evaluación de patrones lingüísticos.
5. Se muestra un panel de resultados con el porcentaje de probabilidad de IA, una etiqueta descriptiva y métricas avanzadas (Perplejidad y Ráfaga).

## Tecnologías Utilizadas

* Flutter / Dart
* Material 3 (Componentes de interfaz y tipografía)

## Cómo Ejecutarlo

Asegúrate de tener instalado [Flutter](https://docs.flutter.dev/get-started/install).

1. Clona el repositorio.
2. Ejecuta `flutter pub get` para instalar las dependencias.
3. Ejecuta `flutter run` para probarlo en tu dispositivo o simulador preferido.

---

## Acerca de CouldAI

Esta aplicación fue generada con [CouldAI](https://could.ai), un constructor de aplicaciones con inteligencia artificial para plataformas cruzadas que convierte *prompts* en aplicaciones nativas reales para iOS, Android, Web y Escritorio mediante agentes autónomos de IA que diseñan, construyen, prueban, despliegan e iteran aplicaciones listas para producción.
