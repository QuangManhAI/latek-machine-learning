Lỗi 1: Chỉ số Ridge Scratch trong báo cáo sai hoàn toàn
Vị trí lỗi
Báo cáo trang 46, Table 3.5 ghi:
Model
RMSLE
MAE
RMSE
R²
Ridge scratch
0.545
98.450
420.310
0.887
MLP scratch
0.521
95.320
398.150
0.898

Output notebook Cell In[19] thực tế:
Model
RMSLE
MAE
RMSE
R²
Ridge scratch
0.7990
218.5730
1,368.9355
-0.2025
MLP scratch
0.6043
131.1944
695.7009
0.6894

 
Lỗi 2 :Báo cáo để trống MAE/RMSE/R² của các log-feature models
1. Vị trí lỗi
Báo cáo trang 46, Table 3.5 để trống cho Ridge + log features và MLP + log features.
Output notebook Cell In[27] đã có đầy đủ metric:
Model
RMSLE
MAE
RMSE
R²
Ridge LogFeat
0.5126
99.4735
337.4363
0.9269
MLP LogFeat
0.4803
95.3962
306.0638
0.9399
HGB LogFeat
0.4644
90.5285
365.3726
0.9143

 
 
Lỗi 3 : Mức cải thiện nhờ log feature bị tính sai
1. Vị trí lỗi
Báo cáo trang 43-44 và trang 46 ghi:
Ridge: 0.545 → 0.513, delta −0.032.
MLP: 0.521 → 0.480, delta −0.041.
Output notebook Cell In[28]:
Ridge : 0.7990 → 0.5126  (↓ 0.2864)
MLP   : 0.6043 → 0.4803  (↓ 0.1240)
HGB   : 0.4644 → 0.4644  (= 0.0000)
2. Phân tích điểm sai lệch
Giá trị log-feature gần đúng, nhưng giá trị raw-feature dùng làm mốc sai. Vì vậy delta cũng sai.
Kết quả thật cho thấy log transform quan trọng hơn nhiều so với báo cáo:
Ridge giảm RMSLE khoảng 0.2864;
MLP giảm khoảng 0.1240.
 
 
Lỗi 4 : Báo cáo khẳng định Ensemble tốt nhất MAE, RMSE và R² là sai
1. Vị trí lỗi
Báo cáo  trang 46 ghi Ensemble “dominates on MAE, RMSE and R²”.
Output notebook Cell In[28]:
Model
RMSLE
MAE
RMSE
R²
HGB Raw Target
0.9959
76.3917
260.2313
0.9565
Ensemble
0.4831
77.8333
283.2451
0.9485

2. Phân tích điểm sai lệch
HGB Raw Target tốt hơn Ensemble trên cả ba metric:
MAE thấp hơn;
RMSE thấp hơn;
R² cao hơn.
Ensemble chỉ là mô hình cân bằng tốt:
RMSLE tốt hơn rất nhiều so với HGB Raw Target;
secondary metrics vẫn tốt;
nhưng không phải best tuyệt đối.
Báo cáo bỏ HGB Raw Target khỏi Table 3.5 nên dẫn đến kết luận sai.
 
Lỗi 5 : lag_16 bị mô tả nhầm là chu kỳ hai tuần
1. Vị trí lỗi
Báo cáo trang 39, mục 3.2.4, phần giải thích lag_16 ghi: “captures the bi-weekly recurrence pattern”.
Code Notebook store_sales_forecasting_new_data.iptnb, cell 13:
for lag in [16, 28, 364]:
	out[f"lag_{lag}"] = grouped_sales.shift(lag)
Notebook phần Problem Definition giải thích lag tối thiểu 16 ngày nhằm khớp với forecast horizon 16 ngày.
2. Phân tích điểm sai lệch
“Bi-weekly” thường là chu kỳ 14 ngày, không phải 16 ngày. Trong project này, lag_16 không được tạo ra vì chu kỳ hai tuần mà vì:
test horizon dài 16 ngày;
tại mỗi thời điểm dự báo, giá trị gần nhất chắc chắn quan sát được là sales cách đó 16 ngày;
đây là cơ chế chống leakage.
Lỗi 6 - Báo cáo chọn sai baseline tốt nhất theo RMSLE
1. Vị trí lỗi
Báo cáo trang 41, mục 3.2.7 ghi: “The best baseline, Lag_28, achieves RMSLE = 0.627”.
Báo cáo trang 45-46 tiếp tục sử dụng Lag_28 làm best baseline để tính mức cải thiện của HGB.
Code Notebook store_sales_forecasting_new_data.ipynb, Cell In[18]:, đánh giá bốn baseline.
Baseline
RMSLE
Rolling_Mean_56_Shift16
0.5457
Rolling_Mean_28_Shift16
0.5502
Lag_28
0.6274
Lag_16
0.6967

2. Phân tích điểm sai lệch
Do primary metric đã được xác định là RMSLE, baseline tốt nhất phải là:
Rolling_Mean_56_Shift16, RMSLE = 0.5457.
Lag_28 chỉ tốt hơn về:
MAE = 82.8711;
R² = 0.9378.
Việc chọn Lag_28 làm best baseline khiến báo cáo tính sai mức cải thiện của HGB:
Báo cáo: 0.6274 - 0.4644 = 0.1630, cải thiện khoảng 26%.
Đúng theo best RMSLE baseline: 0.5457 - 0.4644 = 0.0813, cải thiện khoảng 14.9%.
 
Lỗi 7 - Rolling mean 56 ngày bị gọi là xu hướng theo quý
1. Vị trí lỗi
Báo cáo trang 40, mô tả rolling_mean_56_shift16 là “slow-moving quarterly trend”.
Code store_sales_forecasting_new_data.ipynb, cell 13 sử dụng cửa sổ đúng 56 ngày.
2. Phân tích điểm sai lệch
56 ngày tương đương khoảng:
8 tuần;
chưa đến 2 tháng.
Một quý thường khoảng 90 ngày. Vì vậy gọi đây là “quarterly trend” không chính xác về thời gian.
 
Lỗi 8 - Batch size của MLP trong báo cáo không khớp code
1. Vị trí lỗi
Báo cáo trang 43, mục Multi-Layer Perceptron ghi batch size thường là 64-256.
Notebook store_sales_forecasting_new_data.ipynb, cell 19, cell 27:
MLPRegressorScratch(
	hidden_dim=16,
	lr=0.01,
	epochs=20,
	batch_size=1024,
	random_state=42
)
model.py, dòng 219-224 cũng mặc định batch_size=1024.
2. Phân tích điểm sai lệch
Báo cáo đang mô tả một cấu hình chung, không phải cấu hình thực tế của project. Project không dùng batch 64-256 mà dùng batch 1024.
Đây là siêu tham số quan trọng vì nó ảnh hưởng:
số lần cập nhật gradient mỗi epoch;
tốc độ huấn luyện;
độ nhiễu của gradient;
khả năng hội tụ.
Lỗi 9 - HGB không hoàn toàn “from scratch” như báo cáo tuyên bố
1. Vị trí lỗi
Báo cáo trang 43, mục 3.2.8 ghi ba model được triển khai from scratch, “no scikit-learn dependencies for the core algorithms”.
model.py, dòng 11 import:
from sklearn.tree import DecisionTreeRegressor
Dòng 350-359, mỗi boosting iteration tạo một DecisionTreeRegressor.
2. Phân tích điểm sai lệch
Phần boosting loop và histogram binning được nhóm tự triển khai, nhưng base learner là cây quyết định của scikit-learn.
Do đó HGB là một hybrid implementation, không phải hoàn toàn pure NumPy/from scratch.
Ridge và MLP mới là hai model tự triển khai trực tiếp bằng NumPy.
 
Lỗi 10 — Báo cáo nói HGB có Early Stopping nhưng code không có
1. Vị trí lỗi
Trong báo cáo: Trang 47, chú thích Figure 3.30:
HGB boosting iterations with train/validation split monitoring for early stopping.
Trong model.py, dòng 349–360:
for m in range(self.max_iter):
	residuals = y_np - F
 
	tree = DecisionTreeRegressor(...)
	tree.fit(X_binned, residuals)
 
	F += self.learning_rate * tree.predict(X_binned)
	self.estimators_.append(tree)
2. Phân tích điểm sai lệch
Code luôn chạy đủ:
range(self.max_iter)
Không có:
Validation set truyền vào fit().
n_iter_no_change.
patience.
So sánh validation loss.
Điều kiện break.
Khôi phục model tại iteration tốt nhất.
Notebook chỉ tính lại validation loss sau khi model đã train xong để vẽ biểu đồ. Việc vẽ loss theo iteration không phải early stopping.
Lỗi 11 - Số dòng final training trong báo cáo sai
1. Vị trí lỗi
Báo cáo trang 45, mục 3.2.11 ghi: 648,648 fit rows + 28,512 validation rows = 677,160 rows.
Output notebook Cell In[33]:
Final fit rows: (650430, 24)
Test feature rows: (28512, 24)
2. Phân tích điểm sai lệch
Code không ghép trực tiếp fit_df + valid_df.
Nó tạo lại cửa sổ final bằng điều kiện max_date - 365 days, nên số dòng thực tế là 650,430, không phải 677,160.
Con số 677,160 còn ngụ ý khoảng 380 ngày quan sát, không phù hợp với mô tả “all 365 recent days”.
Lỗi 12 - Nhận xét về R² và “all ML models improve” không đúng
1. Vị trí lỗi
Báo cáo trang 46 ghi Lag_28 có R² tốt nhất trong các individual models.
Figure 3.33, trang 48 ghi “all ML models improve over Lag_28 baseline”.
Output notebook cho thấy:
HGB Raw Target: R² = 0.9565.
MLP LogFeat: R² = 0.9399.
Lag_28: R² = 0.9378.
Ridge raw: RMSLE = 0.7990, tệ hơn Lag_28 = 0.6274.
HGB Raw Target: RMSLE = 0.9959, cũng tệ hơn Lag_28.
2. Phân tích điểm sai lệch
Hai khẳng định trên chỉ đúng khi cố tình giới hạn vào một tập con model, nhưng báo cáo đang trình bày như kết luận cho toàn bộ thí nghiệm.
Không thể nói “all ML models improve” vì ít nhất:
Ridge raw không cải thiện;
HGB Raw Target không cải thiện RMSLE.
Lỗi 13 : Đơn vị MAE/RMSE bị mô tả thành tiền tệ
1. Vị trí lỗi
Báo cáo trang 41, ví dụ giải thích RMSLE sử dụng “$10 miss”.
Báo cáo trang 42, chú thích Table 3.5 gọi MAE và RMSE là “dollar-scale error magnitudes”.
Code đặt target là sales, không phải revenue.
2. Phân tích điểm sai lệch
Dataset Store Sales dự đoán lượng sales theo store-family-date. Đây không phải doanh thu bằng USD.
Do đó:
MAE là sai số trung bình theo đơn vị sales;
RMSE cũng theo đơn vị sales;
không nên gọi là dollar error.
 
 
 
 
 
 
 
 
 
 
 
 
 
 

