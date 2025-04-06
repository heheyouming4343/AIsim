import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QLabel, QVBoxLayout, QWidget

def main():
    print("Starting test application...")
    app = QApplication(sys.argv)
    print("QApplication created")
    
    window = QMainWindow()
    window.setWindowTitle("PyQt5 Test")
    window.setGeometry(100, 100, 400, 300)
    
    central_widget = QWidget()
    window.setCentralWidget(central_widget)
    layout = QVBoxLayout(central_widget)
    
    label = QLabel("PyQt5 Test Window")
    label.setAlignment(Qt.AlignCenter)
    layout.addWidget(label)
    
    print("Window created")
    window.show()
    print("Window shown")
    
    sys.exit(app.exec_())

if __name__ == "__main__":
    main() 