"""
Reisim强化学习训练脚本
"""

import os
import sys
import time
import numpy as np
from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget, QVBoxLayout, QLabel, QPushButton, QTextEdit
from PyQt5.QtCore import QTimer, Qt
from stable_baselines3 import PPO
from stable_baselines3.common.vec_env import DummyVecEnv
from stable_baselines3.common.callbacks import CheckpointCallback, EvalCallback
from stable_baselines3.common.monitor import Monitor

# 添加父目录到Python路径
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from reisim_gym import ReisimEnv
from reisim_gym.bridge import start_bridge, stop_bridge, get_bridge

class TrainingWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        print("初始化训练窗口...")
        
        self.setWindowTitle("Reisim 强化学习训练")
        self.setGeometry(100, 100, 1000, 800)
        
        # 创建中央部件和布局
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)
        
        # 创建状态标签
        self.status_label = QLabel("准备开始训练")
        self.status_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(self.status_label)
        
        # 创建日志文本区域
        self.log_text = QTextEdit()
        self.log_text.setReadOnly(True)
        layout.addWidget(self.log_text)
        
        # 创建按钮
        self.init_button = QPushButton("初始化代理")
        self.init_button.clicked.connect(self.initialize_agent)
        layout.addWidget(self.init_button)
        
        self.start_button = QPushButton("开始训练")
        self.start_button.clicked.connect(self.start_training)
        self.start_button.setEnabled(False)
        layout.addWidget(self.start_button)
        
        self.stop_button = QPushButton("停止训练")
        self.stop_button.clicked.connect(self.stop_training)
        self.stop_button.setEnabled(False)
        layout.addWidget(self.stop_button)
        
        # 初始化训练变量
        self.env = None
        self.model = None
        self.training_timer = QTimer()
        self.training_timer.timeout.connect(self.training_step)
        self.is_training = False
        self.total_timesteps = 0
        self.max_timesteps = 1000000  # 100万步
        
        # 创建目录
        os.makedirs("models", exist_ok=True)
        os.makedirs("logs", exist_ok=True)
        
        self.log("训练窗口初始化完成")
    
    def log(self, message):
        """添加日志消息"""
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
        log_message = f"[{timestamp}] {message}"
        print(log_message)
        self.log_text.append(log_message)
        # 滚动到底部
        scrollbar = self.log_text.verticalScrollBar()
        scrollbar.setValue(scrollbar.maximum())
    
    def initialize_agent(self):
        """初始化Reisim代理"""
        try:
            self.log("初始化代理...")
            
            # 启动通信桥接
            if not get_bridge():
                start_bridge(host='127.0.0.1', port=10000)
                self.log("通信桥接已启动")
            
            # 创建并包装环境
            self.env = ReisimEnv(
                agent_id=1,
                max_steps=1000,
                reward_scaling=1.0,
                simulation_mode=False  # 使用实际的Reisim
            )
            self.env = Monitor(self.env, "logs")
            self.env = DummyVecEnv([lambda: self.env])
            self.log("环境创建并包装完成")
            
            # 启用开始训练按钮
            self.start_button.setEnabled(True)
            self.init_button.setEnabled(False)
            self.status_label.setText("代理初始化完成，可以开始训练")
            
        except Exception as e:
            self.log(f"初始化过程中出错: {str(e)}")
            self.status_label.setText(f"错误: {str(e)}")
    
    def start_training(self):
        if self.is_training:
            return
        
        try:
            self.log("开始训练...")
            self.is_training = True
            self.start_button.setEnabled(False)
            self.stop_button.setEnabled(True)
            
            # 创建回调函数
            checkpoint_callback = CheckpointCallback(
                save_freq=10000,
                save_path="models/",
                name_prefix="reisim_model"
            )
            
            eval_callback = EvalCallback(
                self.env,
                best_model_save_path="models/best/",
                log_path="logs/",
                eval_freq=50000,
                deterministic=True,
                render=False
            )
            
            # 创建或加载模型
            if os.path.exists("models/latest_model.zip"):
                self.log("加载已有模型...")
                self.model = PPO.load(
                    "models/latest_model.zip",
                    env=self.env,
                    tensorboard_log="logs/"
                )
            else:
                self.log("创建新模型...")
                self.model = PPO(
                    "MlpPolicy",
                    self.env,
                    learning_rate=3e-4,
                    n_steps=2048,
                    batch_size=64,
                    n_epochs=10,
                    gamma=0.99,
                    gae_lambda=0.95,
                    clip_range=0.2,
                    tensorboard_log="logs/",
                    verbose=1
                )
            
            self.callbacks = [checkpoint_callback, eval_callback]
            
            # 启动训练计时器
            self.training_timer.start(100)  # 每100ms更新一次
            self.status_label.setText("训练进行中...")
            self.log("训练已开始")
            
        except Exception as e:
            self.log(f"开始训练时出错: {str(e)}")
            self.stop_training()
    
    def stop_training(self):
        if not self.is_training:
            return
        
        self.log("停止训练...")
        self.training_timer.stop()
        
        if self.model:
            try:
                self.model.save("models/latest_model")
                self.log("模型已保存")
            except Exception as e:
                self.log(f"保存模型时出错: {str(e)}")
        
        self.start_button.setEnabled(True)
        self.stop_button.setEnabled(False)
        self.is_training = False
        self.status_label.setText("训练已停止")
    
    def training_step(self):
        if not self.is_training or not self.model:
            return
        
        try:
            # 训练一小段时间
            self.model.learn(
                total_timesteps=1000,
                callback=self.callbacks,
                reset_num_timesteps=False,
                tb_log_name="reisim"
            )
            
            self.total_timesteps = self.model.num_timesteps
            
            # 更新状态
            progress = (self.total_timesteps / self.max_timesteps) * 100
            self.status_label.setText(
                f"训练中... 步数: {self.total_timesteps} / {self.max_timesteps} ({progress:.1f}%)"
            )
            
            # 记录进度
            if self.total_timesteps % 10000 == 0:
                self.log(f"已完成 {self.total_timesteps} 步 ({progress:.1f}%)")
                # 保存模型
                self.model.save(f"models/reisim_model_{self.total_timesteps}")
            
            # 检查是否完成训练
            if self.total_timesteps >= self.max_timesteps:
                self.log("训练完成！")
                self.stop_training()
                
        except Exception as e:
            self.log(f"训练过程中出错: {str(e)}")
            self.stop_training()
    
    def closeEvent(self, event):
        """窗口关闭时清理"""
        self.log("关闭窗口...")
        self.stop_training()
        if self.env:
            self.env.close()
        event.accept()

def main():
    print("启动Reisim强化学习训练程序...")
    app = QApplication(sys.argv)
    
    window = TrainingWindow()
    window.show()
    
    sys.exit(app.exec_())

if __name__ == "__main__":
    main() 