-- 错题示例数据
-- 插入20个错题示例，其中随机10道有题目图片

-- 获取名为user的用户ID
SET @user_id = (SELECT user_id FROM sys_user WHERE user_name = 'user' LIMIT 1);

-- 如果user用户不存在，则使用user_id=2作为默认值
SET @user_id = IFNULL(@user_id, 2);

-- 1. 有图片的错题
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, create_by, create_time, remark) VALUES
(@user_id, '已知函数 f(x) = x² + 2x - 3，求 f(x) = 0 的解。', 'https://img.makis-life.cn/troubleConqueror/1.png', '使用因式分解：f(x) = (x+3)(x-1) = 0，所以 x = -3 或 x = 1', NULL, '解答题', '数学,函数,一元二次方程', '0', 'test', NOW(), NULL),

(@user_id, '计算：∫(0 to π) sin(x) dx', 'https://img.makis-life.cn/troubleConqueror/2.png', '∫(0 to π) sin(x) dx = [-cos(x)](0 to π) = -cos(π) + cos(0) = -(-1) + 1 = 2', NULL, '解答题', '数学,积分,三角函数', '0', 'test', NOW(), NULL),

(@user_id, '下列哪个选项是正确的？\nA. 2+2=5\nB. 2+2=4\nC. 2+2=6\nD. 2+2=3', 'https://img.makis-life.cn/troubleConqueror/3.png', '正确答案是B。2+2=4是基本的数学运算。', NULL, '选择题', '数学,基础运算', '0', 'test', NOW(), NULL),

(@user_id, '求函数 y = 2x + 1 在点 (1, 3) 处的切线斜率。', 'https://img.makis-life.cn/troubleConqueror/4.png', '函数 y = 2x + 1 的导数为 y\' = 2，所以切线斜率为 2。', NULL, '解答题', '数学,导数,切线', '0', 'test', NOW(), NULL),

(@user_id, '解方程：3x - 7 = 2x + 5', 'https://img.makis-life.cn/troubleConqueror/5.png', '3x - 7 = 2x + 5\n3x - 2x = 5 + 7\nx = 12', NULL, '解答题', '数学,方程,一元一次方程', '0', 'test', NOW(), NULL),

(@user_id, '已知三角形三边长分别为 3、4、5，判断这是什么类型的三角形？', 'https://img.makis-life.cn/troubleConqueror/6.png', '因为 3² + 4² = 9 + 16 = 25 = 5²，满足勾股定理，所以这是一个直角三角形。', NULL, '选择题', '数学,几何,三角形', '0', 'test', NOW(), NULL),

(@user_id, '计算：log₂(8) = ?', 'https://img.makis-life.cn/troubleConqueror/7.png', '因为 2³ = 8，所以 log₂(8) = 3', NULL, '填空题', '数学,对数', '0', 'test', NOW(), NULL),

(@user_id, '求数列 2, 4, 8, 16, ... 的第10项。', 'https://img.makis-life.cn/troubleConqueror/8.png', '这是一个等比数列，首项 a₁ = 2，公比 r = 2。第10项 a₁₀ = a₁ × r⁹ = 2 × 2⁹ = 2¹⁰ = 1024', NULL, '解答题', '数学,数列,等比数列', '0', 'test', NOW(), NULL),

(@user_id, '已知圆的半径为 5cm，求圆的面积。', 'https://img.makis-life.cn/troubleConqueror/9.png', '圆的面积公式为 S = πr² = π × 5² = 25π cm² ≈ 78.54 cm²', NULL, '解答题', '数学,几何,圆', '0', 'test', NOW(), NULL),

(@user_id, '化简：√(16) + √(9) = ?', 'https://img.makis-life.cn/troubleConqueror/10.png', '√(16) = 4，√(9) = 3，所以 √(16) + √(9) = 4 + 3 = 7', NULL, '填空题', '数学,根式', '0', 'test', NOW(), NULL),

-- 2. 没有图片的错题
(@user_id, '下列哪个是质数？\nA. 4\nB. 6\nC. 7\nD. 8', NULL, '正确答案是C。质数是只能被1和自身整除的大于1的自然数。7只能被1和7整除，所以是质数。', NULL, '选择题', '数学,质数', '0', 'test', NOW(), NULL),

(@user_id, '计算：15 ÷ 3 × 2 = ?', NULL, '按照运算顺序，先算除法：15 ÷ 3 = 5，再算乘法：5 × 2 = 10', NULL, '填空题', '数学,四则运算', '0', 'test', NOW(), NULL),

(@user_id, '已知 a = 3, b = 4，求 a² + b² 的值。', NULL, 'a² + b² = 3² + 4² = 9 + 16 = 25', NULL, '填空题', '数学,代数', '0', 'test', NOW(), NULL),

(@user_id, '解不等式：2x + 3 > 7', NULL, '2x + 3 > 7\n2x > 7 - 3\n2x > 4\nx > 2', NULL, '解答题', '数学,不等式', '0', 'test', NOW(), NULL),

(@user_id, '求函数 f(x) = x³ 的导数。', NULL, '使用幂函数求导公式：(xⁿ)\' = nxⁿ⁻¹，所以 f\'(x) = 3x²', NULL, '解答题', '数学,导数', '0', 'test', NOW(), NULL),

(@user_id, '已知平行四边形的底为 8cm，高为 5cm，求面积。', NULL, '平行四边形的面积公式为 S = 底 × 高 = 8 × 5 = 40 cm²', NULL, '填空题', '数学,几何,平行四边形', '0', 'test', NOW(), NULL),

(@user_id, '计算：(-3) × (-4) = ?', NULL, '两个负数相乘，结果为正数：(-3) × (-4) = 12', NULL, '填空题', '数学,负数运算', '0', 'test', NOW(), NULL),

(@user_id, '已知等差数列的首项为 5，公差为 3，求第5项。', NULL, '等差数列通项公式：aₙ = a₁ + (n-1)d = 5 + (5-1)×3 = 5 + 12 = 17', NULL, '解答题', '数学,数列,等差数列', '0', 'test', NOW(), NULL),

(@user_id, '求函数 y = x² - 4x + 3 的顶点坐标。', NULL, '对于二次函数 y = ax² + bx + c，顶点横坐标 x = -b/(2a) = -(-4)/(2×1) = 2\n将 x = 2 代入得 y = 2² - 4×2 + 3 = 4 - 8 + 3 = -1\n所以顶点坐标为 (2, -1)', NULL, '解答题', '数学,二次函数,顶点', '0', 'test', NOW(), NULL),

(@user_id, '化简分式：(x² - 4) / (x - 2)', NULL, '分子因式分解：x² - 4 = (x+2)(x-2)\n所以 (x² - 4) / (x - 2) = (x+2)(x-2) / (x-2) = x + 2（其中 x ≠ 2）', NULL, '解答题', '数学,分式,因式分解', '0', 'test', NOW(), NULL);

