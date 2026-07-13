Lỗi 1. Mô tả “loại dấu câu, chỉ giữ chữ cái, chữ số và khoảng trắng” không đúng hoàn toàn
1.      Vị trí lỗi
Báo cáo: trang PDF 7, bước 4, mục Punctuation removal.
Code: src/preprocess.py, dòng 109–116.
2. Phân tích điểm sai lệch
Báo cáo viết rằng pipeline “keep only letters, digits, and whitespace”.
Nhưng code vẫn cho phép dấu nháy đơn và dấu gạch nối:
Code không xóa toàn bộ dấu câu, vì các từ như “don't”, “re-entry” hoặc “limited-time” vẫn có thể được giữ nguyên.
Lỗi 2. Báo cáo nói chỉ dùng nội dung email nhưng code ghép cả tiêu đề và nội dung
1. Vị trí lỗi trong báo cáo: Khoảng trang 17, phần mô tả nhóm đặc trưng “Text only”. Báo cáo sử dụng cụm từ “TF-IDF on cleaned body text”, khiến người đọc hiểu rằng chỉ phần body được dùng.
Vị trí lỗi trong code: File src/preprocess.py, dòng 128–129.
2. Phân tích điểm sai lệch
Code tạo cột text bằng cách nối hai trường subject và body, sau đó mới làm sạch và đưa vào TF-IDF.
Đây là sai lệch quan trọng vì tiêu đề email thường chứa tín hiệu phân loại mạnh như “Urgent”, “Limited offer”, “Win money” hoặc “Claim prize”. Nếu báo cáo chỉ nói dùng body thì phần mô tả đặc trưng không phản ánh đúng dữ liệu đầu vào của mô hình.
data["text"] = data[["subject", "body"]].fillna("").agg(" ".join, axis=1)
 data["clean_text"] = data["text"].map(clean_email_text)
Lỗi 3. Báo cáo nói có 18 cấu hình, code thực tế chạy 15 cấu hình
1. Vị trí lỗi
trong báo cáo: Trang 18, mục 2.2.12 “Threshold Tuning”. Báo cáo ghi: 3 training strategies × 2 feature sets × 3 models = 18 combinations.
trong code: src/model_from_scratch.py, dòng 653–681. Nhóm Text only có 3 mô hình, nhưng nhóm Text + metadata chỉ có 2 cấu hình SVM.
2. Phân tích điểm sai lệch
Mỗi chiến lược dữ liệu không chạy 6 cấu hình. Thực tế, nhóm Text only chạy 3 mô hình gồm Naive Bayes, Logistic Regression và calibrated Linear SVM; nhóm Text + metadata chỉ chạy hai cấu hình Linear SVM với C=0.5 và C=1.0.
Vì có ba chiến lược dữ liệu, tổng số cấu hình là 3 × (3 + 2) = 15, không phải 18.
Text only:
 - Naive Bayes
 - Logistic Regression
 - Linear SVM (Calibrated)

 Text + metadata:
 - Linear SVM (Meta C0.5)
 - Linear SVM (Meta C1)

 Tổng số: 3 × (3 + 2) = 15 cấu hình
Lỗi 4. TARGET_FPR trong báo cáo khác với giá trị chạy trong code
1. Vị trí lỗi trong báo cáo: Trang 17, phần mã minh họa Threshold Tuning. Báo cáo ghi TARGET_FPR = 0.008 và TARGET_TPR = 0.990.
Vị trí lỗi trong code: Notebook notebooks/lab01.ipynb, cell 57, và file train.py, khoảng dòng 117–120. Cả hai đều sử dụng target_fpr=0.01 và target_tpr=0.99.
2. Phân tích lỗi
Báo cáo cho rằng giới hạn FPR là 0.8%, nhưng code thực tế sử dụng giới hạn 1%.
Mặc dù kết quả cuối có FPR thấp hơn 0.8%, điều đó không làm cho giá trị cấu hình 0.008 trong báo cáo trở thành đúng. Báo cáo phải mô tả đúng tham số đã dùng để chạy thí nghiệm.
Lỗi 5. Báo cáo chọn V2 Merged nhưng kết quả notebook chọn Balanced
1. Vị trí lỗi trong báo cáo: Khoảng trang 20, mục “Results and Analysis”. Báo cáo ghi chiến lược cuối cùng là V2 Merged kết hợp Text + Metadata và Linear SVM Meta C1.
Vị trí trong code: Notebook notebooks/lab01.ipynb, cell 57 và phần Failure Analysis. Output ghi rõ: “Validation-selected candidate: Balanced / Text + metadata / Linear SVM (Meta C1)”.
2. Phân tích
Các giá trị threshold=0.0889, validation FPR=0.0064, validation TPR=0.9989, test FPR=0.0092 và test TPR=0.9978 trong báo cáo thực chất thuộc dòng Balanced.
Báo cáo đã lấy metrics của Balanced nhưng gắn nhãn chiến lược V2 Merged. Đây là mâu thuẫn nghiêm trọng nhất vì nó thay đổi kết luận về chiến lược dữ liệu
3. Cách sửa
Vì metrics hiện tại thuộc Balanced, sửa toàn bộ đoạn kết quả thành:
“Strategy: Balanced with Text + Metadata features. The training pool was downsampled to 2,672 ham and 2,672 spam emails. Among the evaluated configurations, Linear SVM (Meta C1) achieved the selected validation operating point with threshold 0.0889.”
Đồng thời bỏ các nhận định:
“supplementary ham data proved decisive”
 “V2 Merged was the best of both worlds”
V2 vẫn có thể được trình bày là một chiến lược được thử nghiệm, nhưng không được gọi là cấu hình chiến thắng.
Lỗi 6. Tuyên bố scratch model đồng thuận trên 99,5% với sklearn là không đúng
1. Vị trí lỗi trong báo cáo: Khoảng trang 16, mục “Scratch vs. sklearn Verification”. Báo cáo kết luận các mô hình đạt mức đồng thuận trên 99.5%.
Vị trí lỗi trong code: Notebook notebooks/lab01.ipynb, cell 56.
Naive Bayes disagreement: 0.000
Logistic Regression disagreement: 0.043
Linear SVM disagreement: 0.037
2. Phân tích
Mức đồng thuận thực tế là 100.0% với Naive Bayes, 95.7% với Logistic Regression và 96.3% với Linear SVM.
Chỉ Naive Bayes đạt trên 99.5%. Vì vậy, không thể dùng một kết luận chung rằng cả ba scratch model đều gần như trùng khớp hoàn toàn với sklearn.
Naive Bayes disagreement   	= 0.000  -> agreement 100.0%
 Logistic Regression disagreement = 0.043 -> agreement 95.7%
 Linear SVM disagreement      	= 0.037 -> agreement 96.3%
Lỗi 7. Báo cáo thiếu F1-score của mô hình cuối cùng
Vị trí trong báo cáo
Phần Results and Analysis, khoảng trang 20–21
Báo cáo chủ yếu chỉ đưa TPR và FPR.
Trong khi đề bài yêu cầu đánh giá bằng:
Accuracy;
Precision;
Recall;
F1-score.
Vị trí trong code
File:
src/model_from_scratch.py
Khoảng dòng 442–473, hàm metrics_at_threshold() tính:
accuracy
precision
recall
TPR
FPR
FNR
TNR
balanced_accuracy
Nhưng không có: f1
Danh sách kết quả ở dòng 771–775 cũng không chứa F1.
Điểm sai
Mô hình cuối được chọn ở một threshold riêng, nhưng code không tính F1 tại threshold đó. Vì vậy báo cáo chưa đáp ứng đầy đủ metric theo yêu cầu đề bài
 
NEW UPDATE


Lỗi 8 : Trang 3 – Executive Summary: lỗi rõ ràng
Báo cáo ghi: “binary text classification (5,574 messages)”
Trong khi phần Lab 01 của chính báo cáo lại sử dụng các mốc:
Raw data: 18.807 email.
Sau tiền xử lý: 9.886 email.
Sau cân bằng: 9.002 email.
Tỷ lệ 73% ham và 27% spam.
Test set: 1.978 email.
Không có mốc 5.574 nào được giải thích trong quy trình hiện tại. Vì vậy, con số này nhiều khả năng là số liệu còn sót lại từ phiên bản cũ hoặc từ một dataset khác
Cách sửa :
Đổi: “binary text classification (5,574 messages)”
thành: “binary text classification using 18,807 raw emails, with 9,886 preprocessed emails used for model development”
 
Lỗi 9. Cùng một đoạn dùng cả giới hạn FPR 0.010 và 0.008
1. Vị trí cần sửa
Trang PDF 17, đoạn code ghi:
TARGET_FPR = 0.010
TARGET_TPR = 0.990
Nhưng trang PDF 18, phần dưới lại ghi:
the threshold that maximizes TPR while keeping validation FPR ≤ 0.008 is selected.
Trong đoạn tiếp theo lại ghi điều kiện:
validation FPR ≤ 0.010 and validation TPR ≥ 0.990

Lỗi 10 : Figure 2.8 không khớp với caption và test set
1.Vị trí trong báo cáo
Trang 21, Figure 2.8.Caption ghi: Four-panel confusion matrix: centroid baseline vs. three scratch models
Nhưng trang này chỉ có một confusion matrix, không phải bốn panel.
Code : Notebook Cell 55 thực sự tạo bốn confusion matrix:
fig, axes = plt.subplots(1, 4, figsize=(16, 3.8))
bao gồm:
Centroid.
Scratch Naive Bayes.
Scratch Logistic Regression.
Scratch SVM.
Lỗi 11 :  Tiêu đề và phân tích Confusion Matrix vẫn nói tất cả mô hình dùng threshold 0.500
1. Vị trí cần sửa
Trang PDF 16, mục:
Four-Panel Confusion Matrix (Default Threshold 0.500)
Câu tiếp theo:
All four models (centroid, NB, LR, SVM) are evaluated ... at the default threshold 0.500.
Trang PDF 21, chú thích Figure 2.8 cũng ghi:
three scratch models at default threshold 0.500.
2. Vì sao đây là lỗi
Bốn mô hình không dùng cùng một quy tắc ngưỡng:
Logistic Regression: thường dùng xác suất 0.5.
Naive Bayes: chọn lớp có xác suất hậu nghiệm lớn hơn; trong bài toán nhị phân có thể diễn giải gần với 0.5.
Linear SVM: dùng ranh giới decision score bằng 0, không phải 0.5.
Nearest Centroid: chọn centroid có cosine similarity lớn hơn, không có threshold 0.5.
Do đó, câu “all models at threshold 0.500” không đúng với code.
 
Lỗi 12: Báo cáo đã thêm F1-score nhưng số liệu F1 đang sai
Vị trí trong báo cáo
Trang 20, mục 2.3 Results and Analysis, báo cáo ghi:
accuracy = 0.994, precision = 0.991, recall = 0.998, F1-score = 0.995.
Việc bổ sung F1-score là đúng hướng, nhưng hai giá trị Precision và F1-score không khớp với output notebook.
Vị trí trong code
Notebook Cell threshold tuning ghi mô hình Balanced Meta C1 có:
TN = 1078
FP = 10
FN = 2
TP = 888
 
accuracy  = 0.9939
precision = 0.9889
TPR   	= 0.9978
FPR   	= 0.0092
Từ đó:
 
Lỗi 13 : Báo cáo gọi Logistic Regression là SGD nhưng code thực tế là full-batch gradient descent
1. Vị trí cần sửa
Trang PDF 15, bảng 2.3 ghi:
Logistic Regression — Discriminative (SGD)
Đoạn sau ghi:  minimizes binary cross-entropy via stochastic gradient descent.
 Vị trí trong code Code tính gradient bằng toàn bộ ma trận :
scores = x @ self.weights_ + self.bias_
error = probabilities - y_binary
gradient_w = (x.T @ error) / n_samples + self.l2 * self.weights_
3. Phân tích lỗi
SGD thường cập nhật trọng số từ:
từng mẫu;
hoặc từng mini-batch.
Code ở đây dùng toàn bộ tập huấn luyện trong mỗi epoch nên chính xác hơn phải gọi là:
batch gradient descent;
hoặc full-batch gradient descent.
Lỗi 14 : Figure 2.9 để sai hình
Trang 22 – Figure 2.9 Chú thích ghi:
Severe class imbalance — approximately 73% ham vs. 27% spam.
Nhưng chính biểu đồ lại thể hiện hai cột ham và spam bằng nhau, mỗi lớp khoảng 4.501 mẫu. Đây rõ ràng là biểu đồ của dữ liệu đã cân bằng 50/50, không phải dữ liệu 73/27.
 
Lỗi 15 : Cách giải thích threshold của Linear SVM vẫn sai
Vị trí trong báo cáo
Các vị trí cần sửa:
Trang 16: tiêu đề Default Threshold 0.500 áp dụng cho cả SVM.
Trang 20: viết threshold 0.089 “significantly below the default 0.500”.
Trang 20: nói ham score gần 0.000 và spam score gần 1.000.
Trang 24: tiếp tục nói SVM được chuyển từ threshold 0.500 sang 0.089.
Vị trí trong code
Mô hình cuối được tạo tại model_from_scratch.py, khoảng dòng 677–678:
"Linear SVM (Meta C1)": LinearSVC(C=1.0, dual="auto")
Hàm lấy score, khoảng dòng 390–394:
return pipeline.decision_function(texts), "decision_score"
Đối với LinearSVC:
Score là decision score, không phải xác suất.
Score có thể âm hoặc dương.
Threshold mặc định là: 0 không phải 0.5.
Output failure analysis của notebook cũng cho thấy:
Ham median score  = -1.1481
Spam median score =  1.0339
Như vậy câu “ham gần 0, spam gần 1” không khớp với dữ liệu thực tế.
Cách sửa báo cáo
Thay đoạn tại trang 20 bằng:
Linear SVM uses a default decision threshold of 0. The validation-selected threshold is 0.0889, which is slightly higher than zero. Therefore, the final classifier is slightly more conservative when assigning the spam label. These values are decision scores rather than probabilities: ham emails generally receive negative scores, whereas spam emails generally receive positive scores.
Không nên dùng cụm: “extremely confident” vì 0.0889 không phải xác suất 8,89% hoặc 91,11%.
Figure 2.8
Caption nên đổi: Không nên ghi tất cả mô hình đều dùng threshold 0,500:
Logistic Regression và Naive Bayes dùng xác suất 0,5.
Scratch SVM dùng decision threshold 0.
Lỗi 16 : Báo cáo mô tả sai cách quét threshold
1. Vị trí lỗi
Vị trí trong báo cáo
Khoảng trang 18 ghi : thresholds are swept from 0.000 to 0.990 in increments of 0.001
Vị trí trong code : model_from_scratch.py khoảng dòng 404–407, code sử dụng:
fpr, tpr, thresholds = roc_curve(y_true, scores)
2. Phân tích lỗi
Code không tạo danh sách:
0.000, 0.001, 0.002, ..., 0.990
Thay vào đó, roc_curve() tự tạo các threshold dựa trên các giá trị dự đoán của mô hình.
Vì vậy báo cáo đang mô tả một cách thực hiện khác với code.

