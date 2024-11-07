# Detectify

**Detectify** is a Flutter mobile application that uses TensorFlow Lite (TFLite) to perform object detection. The app allows users to pick an image from their device gallery and identifies objects within the image, displaying the labels and confidence levels of detected objects. It's a simple and effective tool for real-time object recognition, built using the power of machine learning and Flutter.

## Features

- Pick an image from the gallery
- Perform object detection using TFLite
- Display object labels and their confidence percentages
- Beautiful and modern UI with Flutter's rich widget set
- Fully responsive design for various screen sizes

## Technologies Used

- **Flutter**: Framework for building the app UI.
- **TensorFlow Lite**: Used for running the object detection model.
- **Google Fonts**: For stylish and readable fonts.
- **Image Picker**: To allow the user to select images from the gallery.

## How to Run

1. Clone this repository:
    ```bash
    git clone https://github.com/yourusername/detectify.git
    ```

2. Navigate to the project directory:
    ```bash
    cd detectify
    ```

3. Install dependencies:
    ```bash
    flutter pub get
    ```

4. Run the app on an emulator or connected device:
    ```bash
    flutter run
    ```

## How to Use

1. Launch the app.
2. Tap on the **"Pick Image from Gallery"** button to select an image.
3. The app will process the image and display the detected objects with their respective confidence levels.

## Model Details

- **Model**: `model_unquant.tflite` (TensorFlow Lite model for object detection)
- **Labels**: `labels.txt` (Labels file corresponding to the model)

Make sure that the model file (`model_unquant.tflite`) and the labels file (`labels.txt`) are placed under the **assets** folder.

## Contributing

If you want to contribute to **Detectify**, feel free to fork this repository, create a new branch, and submit a pull request. We welcome any contributions that help improve the functionality or enhance the user experience of the app.

## License

This project is open source and available under the MIT License. See the [LICENSE](LICENSE) file for more information.

---

**Detectify** is a fun and easy-to-use app to explore the power of machine learning and object detection on your device. Enjoy detecting objects from your photos!
