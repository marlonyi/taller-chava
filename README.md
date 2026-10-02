<div align="center">

# 📊 graficos_app

### Taller de gráficos en Flutter · 260 ejemplos con 4 librerías

Visualización de datos reales de la API pública **DummyJSON** usando
`fl_chart`, `Syncfusion`, `graphic` y `community_charts`.

<br/>

![Flutter](https://img.shields.io/badge/Flutter-3.29-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material 3](https://img.shields.io/badge/Material-3-757575?style=for-the-badge&logo=materialdesign&logoColor=white)
![Tests](https://img.shields.io/badge/tests-5%20passing-10B981?style=for-the-badge&logo=checkmarx&logoColor=white)

![Gráficos](https://img.shields.io/badge/gráficos-260-3B82F6?style=flat-square)
![Básicos](https://img.shields.io/badge/básicos-160-F97316?style=flat-square)
![Avanzados](https://img.shields.io/badge/avanzados-100-8B5CF6?style=flat-square)
![API](https://img.shields.io/badge/API-DummyJSON-E11D48?style=flat-square)

</div>

---

## 📑 Contenido

- [✨ Características](#-características)
- [📚 Librerías](#-librerías)
- [🚀 Cómo ejecutar](#-cómo-ejecutar)
- [🗂️ Estructura del proyecto](#️-estructura-del-proyecto)
- [🔄 Flujo de datos](#-flujo-de-datos)
- [🧪 Pruebas](#-pruebas)

---

## ✨ Características

| | |
|---|---|
| 🌐 **Datos reales** | Consume [`dummyjson.com/products?limit=100`](https://dummyjson.com/products?limit=100) (100 productos con precios, stock, descuentos, ratings y categorías). |
| 📈 **260 gráficos en total** | **65 gráficos por librería**: exactamente **40 básicos** y **25 avanzados** en cada una de las 4 librerías. |
| 🔍 **Buscador y filtros interactivos** | Filtros instantáneos por nivel (Todas, Básicas, Avanzadas) y caja de búsqueda por # de gráfica, título o métrica. |
| ⚡ **Virtualización optimizada** | Renderizado perezoso (`ListView.builder` con evaluación diferida) para máximo rendimiento y desplazamiento suave a 60 FPS. |
| 🗃️ **Agregación avanzada** | Estadísticas multivariables: stock, valor monetario en bodega, precios min/max, percentiles, bandas de precios/rating/descuento. |
| 🔁 **Recarga en vivo** | Botón en AppBar para refrescar los datos directamente desde la API REST. |
| 🧩 **Arquitectura modular** | Separación por módulos (`basic` y `advanced` organizados por librería, modelos puros, servicios inyectables). |
| ✅ **Pruebas unitarias** | Cobertura completa de modelos, agregaciones, llamadas HTTP simuladas y validación de los 260 gráficos únicos. |

---

## 📚 Librerías

<div align="center">

| Pestaña | Librería | Gráficos Básicos | Gráficos Avanzados | Total | Paquete |
|:---:|:---|:---:|:---:|:---:|:---|
| 📉 | **fl_chart** | `1 – 40` (40) | `41 – 65` (25) | **65** | [![pub](https://img.shields.io/badge/pub-fl__chart-02569B?logo=dart)](https://pub.dev/packages/fl_chart) |
| 📊 | **Syncfusion** | `66 – 105` (40) | `106 – 130` (25) | **65** | [![pub](https://img.shields.io/badge/pub-syncfusion__flutter__charts-02569B?logo=dart)](https://pub.dev/packages/syncfusion_flutter_charts) |
| 🍩 | **graphic** | `131 – 170` (40) | `171 – 195` (25) | **65** | [![pub](https://img.shields.io/badge/pub-graphic-02569B?logo=dart)](https://pub.dev/packages/graphic) |
| 📶 | **community_charts** | `196 – 235` (40) | `236 – 260` (25) | **65** | [![pub](https://img.shields.io/badge/pub-community__charts__flutter-02569B?logo=dart)](https://pub.dev/packages/community_charts_flutter) |
| **Total** | **4 Librerías** | **160 Básicos** | **100 Avanzados** | **260 Gráficos** | |

</div>

---

## 🚀 Cómo ejecutar

> [!NOTE]
> Requiere **Flutter 3.29+** y conexión a internet (la app consulta la API al iniciar).

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Ejecutar (web, Windows, Android...)
flutter run -d chrome

# 3. Correr las pruebas unitarias
flutter test
```

---

## 🗂️ Estructura del proyecto

```text
lib/
├── main.dart                               # MaterialApp y tema
├── models/
│   ├── product.dart                        # Product + fromJson + métricas derivadas
│   ├── category_stat.dart                  # Estadísticas agregadas por categoría
│   ├── chart_data.dart                     # ChartData + rangos y agrupaciones
│   ├── chart_item.dart                     # Modelo lazy-load para renderizado óptimo
│   └── models.dart                         # Exporta los modelos
├── services/
│   └── api_service.dart                    # Consumo de la API (http.Client inyectable)
├── theme/
│   └── palette.dart                        # Paleta compartida de colores
├── widgets/
│   ├── chart_card.dart                     # Tarjeta: número, título, nivel y observación
│   └── chart_list_view.dart                # Lista virtualizada con búsqueda y filtros
└── pages/
    ├── home_page.dart                      # Pestañas principales y FutureBuilder
    ├── fl_chart_page.dart                  # Controlador fl_chart (65 gráficos)
    ├── fl_chart/
    │   ├── fl_chart_helpers.dart           # Ejes y leyendas compartidas
    │   ├── fl_chart_basic.dart             # Gráficos 1 a 40 (Básicos)
    │   └── fl_chart_advanced.dart          # Gráficos 41 a 65 (Avanzados)
    ├── syncfusion_page.dart                # Controlador Syncfusion (65 gráficos)
    ├── syncfusion/
    │   ├── syncfusion_basic.dart           # Gráficos 66 a 105 (Básicos)
    │   └── syncfusion_advanced.dart        # Gráficos 106 a 130 (Avanzados)
    ├── graphic_page.dart                   # Controlador graphic (65 gráficos)
    ├── graphic/
    │   ├── graphic_basic.dart              # Gráficos 131 a 170 (Básicos)
    │   └── graphic_advanced.dart           # Gráficos 171 a 195 (Avanzados)
    ├── community_charts_page.dart          # Controlador community_charts (65 gráficos)
    └── community_charts/
        ├── community_charts_helpers.dart   # Adaptador de colores
        ├── community_charts_basic.dart     # Gráficos 196 a 235 (Básicos)
        └── community_charts_advanced.dart  # Gráficos 236 a 260 (Avanzados)
test/
└── chart_data_test.dart                    # 5 pruebas unitarias (valida los 260 gráficos)
```

---

## 🧪 Pruebas

```bash
flutter test
```

| Prueba | Qué verifica |
|---|---|
| `Product.fromJson` | Conversión numérica, descuento y título corto. |
| `ChartData` | Agrupación, promedios, valor de inventario y orden por cantidad. |
| `ApiService` (error) | Lanza excepción controlada si HTTP status != 200. |
| `ApiService` (ok) | Deserializa correctamente la lista de productos de la API. |
| `260 Gráficos` | Verifica exactamente 40 básicos y 25 avanzados en cada una de las 4 librerías (260 únicos del 1 al 260). |

---

<div align="center">

Hecho con 💙 y Flutter

</div>
