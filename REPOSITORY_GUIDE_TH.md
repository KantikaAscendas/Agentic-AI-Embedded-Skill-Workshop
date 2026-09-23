# คู่มืออธิบายไฟล์ใน Agentic AI Embedded Skill Workshop

เอกสารนี้ช่วยให้ผู้สอนอธิบายกับผู้เข้าร่วมได้ว่าไฟล์และโฟลเดอร์แต่ละส่วนใน GitHub มีไว้เพื่ออะไร ต้องเปิดเมื่อใด และไฟล์ใดไม่ควรแก้ไขระหว่างเวิร์กช็อป

## ภาพรวมการใช้งาน

ผู้เข้าร่วมไม่จำเป็นต้องเปิดทุกไฟล์เอง ขั้นตอนหลักมีเพียงดังนี้

1. อ่าน `Workshop Instruction Embedded AI.pdf`
2. เปิดโปรเจกต์ `Aimbdworkshop.prj` ใน MATLAB R2026a
3. รัน `agentic_ai/scripts/workshopPreflight.m` และตรวจสอบว่าแสดง `READY=true`
4. เปิดโฟลเดอร์ repository นี้ใน Codex
5. ให้ Agent ทำงานทีละ Phase โดยใช้ skill `embedded-ai-deployment`
6. ตรวจสอบ Live Script ผลลัพธ์ และหลักฐานที่ Agent สร้างก่อนอนุมัติ Phase ถัดไป

```text
เตรียมเครื่อง
   ↓
ตรวจสอบสภาพแวดล้อมด้วย workshopPreflight.m
   ↓
Part 1 ประเมิน Baseline LSTM
   ↓
Part 2 Import และตรวจสอบ PyTorch MLP
   ↓
Part 3 เปรียบเทียบโมเดลและสร้าง C code
   ↓
ผู้สอนสาธิตการทำงานบน NUCLEO-F767ZI
```

## ไฟล์ระดับบนสุดของ Repository

### `README.md`

เป็นหน้าแรกของ GitHub และเป็นจุดเริ่มต้นแบบย่อ บอกลำดับการเตรียมเครื่อง วิธีเปิดโปรเจกต์ และขอบเขตของเวิร์กช็อป ผู้เข้าร่วมควรอ่านไฟล์นี้ก่อนเริ่ม

### `Workshop Instruction Embedded AI.pdf`

เป็นคู่มือสำหรับผู้เข้าร่วม ใช้เตรียม MATLAB, Codex, MATLAB Agentic Toolkit และ skill `embedded-ai-deployment` ก่อนวันงาน รวมทั้งมี prompt เริ่มต้นสำหรับเวิร์กช็อป

### `Aimbdworkshop.prj`

เป็นไฟล์ MATLAB Project ที่กำหนด project path และเรียกการตั้งค่าที่จำเป็น ให้เปิดไฟล์นี้ก่อนรัน Exercise หรือ Script เพื่อให้ MATLAB หาโฟลเดอร์ข้อมูล โมเดล และ helper functions ได้ถูกต้อง

### `AGENTS.md`

เป็นคำสั่งระดับ repository สำหรับ AI Agent ไม่ใช่แบบฝึกหัดที่ผู้เข้าร่วมต้องรัน ไฟล์นี้กำหนดให้ Agent ใช้ workflow เดียวกัน เช่น ใช้ข้อมูลและ checkpoint ที่เตรียมไว้ ทำงานทีละ Phase หยุดรออนุมัติ และจัดเก็บไฟล์ให้ถูกโฟลเดอร์

ส่วน `MATLAB script authoring` กำหนดให้ Agent สร้างขั้นตอนที่ผู้เข้าร่วมต้องอ่านเป็น plain-text Live Script นามสกุล `.m` ภายใน `agentic_ai/generated` ไฟล์ประเภทนี้เปิดใน MATLAB Live Editor แล้วเห็นคำอธิบาย โค้ด และผลลัพธ์ร่วมกัน แต่ยังอ่านและตรวจสอบการเปลี่ยนแปลงบน GitHub ได้ ต่างจาก `.mlx` ซึ่งเป็นไฟล์ binary

### `license`

ระบุเงื่อนไขการใช้งานไฟล์ตัวอย่างและเนื้อหาที่ดัดแปลงมาจากตัวอย่างของ MathWorks ควรเก็บไว้กับ repository และไม่ควรลบ

### `SECURITY.md`

อธิบายช่องทางสำหรับรายงานปัญหาด้านความปลอดภัย ไม่เกี่ยวกับขั้นตอนทดลองโดยตรง แต่เป็นไฟล์มาตรฐานสำหรับ repository ที่เผยแพร่ให้ผู้อื่นใช้

### `.gitignore` และ `.gitattributes`

เป็นไฟล์ควบคุม Git ผู้เข้าร่วมไม่ต้องแก้ไข `.gitignore` ป้องกันไม่ให้ไฟล์ build ขนาดใหญ่ ผลลัพธ์เฉพาะเครื่อง MEX และ generated code ถูกอัปโหลดกลับเข้า repository โดยไม่ตั้งใจ

## ชุดข้อมูลแบตเตอรี่

### `LGHG2@n10C_to_25degC`

เก็บชุดข้อมูลแบตเตอรี่ LG HG2 ที่เตรียมไว้แล้ว แบ่งเป็นสามส่วน

- `Train` ใช้สำหรับการสร้างหรือ fine-tune โมเดลใน workflow ที่ผู้สอนอนุญาต
- `Validation` ใช้ตรวจสอบโมเดลระหว่างการพัฒนา
- `Test` ใช้ประเมินโมเดลกับข้อมูลที่ไม่ได้ใช้ฝึก โดยครอบคลุมอุณหภูมิ -10, 0, 10 และ 25 องศาเซลเซียส

ในเวิร์กช็อปหนึ่งชั่วโมง ให้ใช้การแบ่งข้อมูลที่เตรียมไว้ ห้ามสร้าง data split ใหม่ เพื่อให้ผู้เข้าร่วมทุกคนได้ผลที่เปรียบเทียบกันได้

## Part 1 AI Modeling

### `Part_1_AI_modeling/Exercise_1.m`

เป็น Live Script ต้นฉบับสำหรับเรียนรู้การสร้างและประเมินโมเดล State-of-Charge เช่น MLP, LSTM, CNN และ GRU ในกิจกรรมแบบเต็ม สำหรับ fast path ของเวิร์กช็อป Agentic AI เราไม่แก้ไขไฟล์นี้ และใช้โมเดล LSTM ที่เตรียมไว้เพื่อเน้นการประเมินหลักฐานจาก Agent

### `Part_1_AI_modeling/models/trainedNetwork.mat`

เป็น Baseline LSTM สำหรับ Part 1 Agent โหลดโมเดลนี้แล้วประเมินกับ test data เพื่อสร้างค่า accuracy และกราฟเปรียบเทียบค่า State-of-Charge จริงกับค่าที่โมเดลทำนาย

### `Part_1_AI_modeling/models/myExampleModel.slx`

เป็นตัวอย่าง Simulink model ที่เชื่อม AI model เข้ากับ simulation ใช้เป็นตัวอย่างสำรองเมื่อผู้เข้าร่วมต้องการดูโครงสร้างใน Simulink

## Part 2 AI Import

### `Part_2_AI_import/Exercise_2.m`

เป็น Live Script ต้นฉบับสำหรับ workflow การนำเข้าโมเดลจาก PyTorch ห้ามแก้ไขระหว่างเวิร์กช็อป Agent จะสร้าง Script ใหม่ใน `agentic_ai/generated` เพื่อให้ตรวจสอบสิ่งที่ Agent ทำได้ทุกขั้นตอน

### `Part_2_AI_import/models/mlp_soc_model.pt2`

เป็นโมเดล MLP ต้นฉบับจาก PyTorch ใช้เป็นแหล่งโครงสร้างและ weights และใช้รันผลอ้างอิงจาก PyTorch สำหรับ equivalence test

### `Part_2_AI_import/models/netPyTorchMLP.mat`

เป็น MATLAB checkpoint ของโมเดลที่นำเข้าไว้แล้ว ใช้เป็นไฟล์สำรองและช่วยให้เดินหน้าต่อได้หากการ import สดใช้เวลานาน

### `Part_2_AI_import/models/exampleModel_PyTorch_import.slx`

เป็น Simulink model ตัวอย่างสำหรับแสดงโมเดล PyTorch ที่นำเข้าและการเชื่อมต่อกับ workflow ใน Simulink

### `Part_2_AI_import/models/closedLoopModel.slx`

เป็นตัวอย่างการนำ AI estimator ไปใช้ในระบบ closed-loop เพื่อให้เห็นบริบทการนำโมเดลไปประกอบกับระบบ ไม่ใช่ไฟล์หลักสำหรับการทดสอบ equivalence 200 จุด

## Part 3 Code Generation

### `Part_3_Code_Gen/Exercise_3.m`

เป็น Live Script ต้นฉบับที่อธิบายการลดขนาดโมเดล การตรวจสอบ และการสร้างโค้ด ใน workshop fast path เราใช้ checkpoint ที่เตรียมไว้และให้ Agent สร้าง Script แยก เพื่อไม่เปลี่ยนไฟล์ต้นฉบับ

### `Part_3_Code_Gen/models/dlnetFineTuned.mat`

เป็น projected และ fine-tuned LSTM ที่เตรียมไว้สำหรับเปรียบเทียบกับ Baseline จุดประสงค์คือแสดง trade-off ระหว่างความแม่นยำกับขนาดโมเดลก่อนสร้างโค้ด

### `Part_3_Code_Gen/models/deployTestData_LSTM.mat`

เป็น test data สำหรับตรวจสอบพฤติกรรมของโมเดลก่อนและหลัง code generation ทำให้การทดสอบ MATLAB, MEX และ target ใช้ input ที่สอดคล้องกัน

### `Part_3_Code_Gen/models/SOC_model_Code_Gen.slx`

เป็น Simulink model สำหรับ workflow สร้าง C/C++ code และการตรวจสอบ deployment ใช้ในการตั้งค่า code generation และสำหรับการสาธิตบน target hardware ของผู้สอน

## โฟลเดอร์ `+helper`

เป็น MATLAB package ที่รวม utility functions ของโปรเจกต์ เช่น หา path ของข้อมูล โหลดข้อมูล เตรียม datastore และประเมิน accuracy ผู้เข้าร่วมไม่ต้องเรียกทุก function โดยตรง และไม่ควรแก้ไขระหว่างเวิร์กช็อป เพราะ Exercise และ Script อื่นอ้างอิง functions เหล่านี้อยู่

## โฟลเดอร์ `agentic_ai`

โฟลเดอร์นี้แยก workflow ที่สร้างโดย AI Agent ออกจาก Exercise ต้นฉบับ ทำให้ผู้เข้าร่วมเห็นชัดว่าไฟล์ใดเป็นต้นฉบับ ไฟล์ใด Agent สร้าง และไฟล์ใดเป็นผลลัพธ์จากเครื่องของตนเอง

### `agentic_ai/scripts/workshopPreflight.m`

ไฟล์นี้เป็นการตรวจสุขภาพเครื่องก่อนเริ่ม workshop โดยตรวจสอบ

- MATLAB release เป็น R2026a หรือใหม่กว่า
- Toolbox ที่จำเป็น เช่น Simulink, Deep Learning Toolbox, MATLAB Coder, Simulink Coder และ Embedded Coder
- Add-on สำหรับ model compression, deep learning code generation และ PyTorch import
- มี C++ MEX compiler ที่ MATLAB ใช้งานได้
- ติดตั้ง skill `embedded-ai-deployment` แล้ว

Script จะแสดงสถานะ `OK` หรือ `MISSING` ของแต่ละรายการ สรุปท้ายด้วย `READY=true` หรือ `READY=false` และบันทึกตารางผลไว้ที่ `agentic_ai/results/preflight.csv`

ไฟล์นี้ไม่ฝึกโมเดล ไม่สร้าง C code และไม่แก้ไข Exercise หน้าที่ของมันคือค้นหาปัญหาการติดตั้งให้พบก่อนเริ่มกิจกรรม เพื่อไม่เสียเวลาแก้ environment ระหว่าง workshop

### `agentic_ai/reference`

เก็บ Script ที่ทีมผู้สอนตรวจสอบแล้ว ใช้เป็น fallback เมื่อผู้เข้าร่วมติด usage limit หรือ Agent สร้าง workflow ไม่สำเร็จภายในเวลาที่กำหนด

- `step01_evaluateBaselineIndependent.m` ประเมิน Baseline LSTM กับ independent test files และสร้าง metrics กับกราฟ
- `step02_inspectPyTorchModel.py` ตรวจสอบโมเดล PyTorch ต้นฉบับและ input/output shape ก่อน import
- `step02_prepareEquivalenceInputs.m` เลือก deterministic inputs จำนวน 200 จุด โดยใช้ 50 จุดจากแต่ละอุณหภูมิ
- `step02_generatePyTorchReference.py` รันโมเดล PyTorch ต้นฉบับเพื่อสร้าง reference outputs
- `step02_importAndInspect.m` import โมเดลเข้า MATLAB ตรวจสอบ layers และ learnable parameters โดยยังไม่ถือว่าผล MATLAB เป็น reference
- `step02_rebuildAndVerifyNative.m` สร้าง MATLAB-native MLP จาก weights ที่นำเข้า แล้วเปรียบเทียบผลกับ PyTorch reference ทั้ง 200 จุด
- `step02_openNativeInDesigner.m` เปิดโมเดลที่ผ่านการตรวจสอบใน Deep Network Designer สำหรับ review gate

Reference scripts ไม่ได้มีไว้ให้ผู้เข้าร่วมข้ามกระบวนการ review แต่ใช้ช่วยให้ workshop เดินหน้าต่อได้เมื่อเวลาจำกัด

### `agentic_ai/generated`

เป็นพื้นที่ที่ Agent สร้าง plain-text Live Script `.m` ใหม่สำหรับแต่ละ Phase ผู้เข้าร่วมควรเปิดไฟล์เหล่านี้ใน MATLAB Live Editor เพื่ออ่านวัตถุประสงค์ ดู code ที่ Agent สร้าง รันทีละส่วน และตรวจสอบผลก่อนอนุมัติขั้นตอนถัดไป

ไฟล์ในโฟลเดอร์นี้ควรตั้งชื่อให้บอกลำดับและหน้าที่ เช่น

```text
step00_environmentDiscovery.m
step01_evaluateBaseline.m
step02_importAndVerifyModel.m
step03_compareCompression.m
step04_validateMex.m
step05_generateCCode.m
step06_hardwarePILValidation.m
```

โฟลเดอร์นี้ถูกละเว้นจาก Git เพราะเนื้อหาอาจต่างกันตาม prompt และเครื่องของผู้เข้าร่วม การเก็บแบบ local ยังช่วยป้องกันไม่ให้อัปโหลดผลทดลองหรือ path เฉพาะเครื่องโดยไม่ตั้งใจ

### `agentic_ai/results`

เก็บหลักฐานจากการทดสอบ เช่น CSV, MAT, JSON, ตาราง metrics และกราฟ PNG ไฟล์ `.gitkeep` มีไว้ให้ GitHub แสดงโฟลเดอร์ว่างนี้ตั้งแต่เริ่มต้น ส่วนผลลัพธ์จริงจะไม่ถูก commit

เมื่อตรวจผล ควรยึดไฟล์ใน `results` เป็นหลักฐานที่ทำซ้ำและเปรียบเทียบได้ ส่วน output ที่แสดงใน Live Editor ใช้สำหรับนำเสนอและอ่านประกอบ

### `agentic_ai/build`

เก็บ MEX, generated C/C++ code, build reports และ artifact ที่เกิดจาก code generation ไฟล์เหล่านี้ขึ้นกับระบบปฏิบัติการ compiler และ target hardware จึงไม่อัปโหลดไปกับ repository

## โฟลเดอร์ `resources/project`

เป็น metadata ที่ MATLAB Project ใช้จัดการ path, labels, shortcuts และ project state ผู้เข้าร่วมไม่ต้องเปิดหรือแก้ไขไฟล์ XML ในโฟลเดอร์นี้โดยตรง

## ไฟล์ใดควรแก้และไฟล์ใดไม่ควรแก้

| ประเภท | แนวทาง |
|---|---|
| `Exercise_1.m`, `Exercise_2.m`, `Exercise_3.m` | อ่านได้ แต่ไม่แก้ไข |
| โมเดลใน `models` | โหลดและตรวจสอบ แต่ไม่เขียนทับ |
| ข้อมูล Train Validation Test | ใช้งานตามที่เตรียมไว้ ไม่สร้าง split ใหม่ |
| `agentic_ai/generated` | Agent สร้างและผู้เข้าร่วม review ได้ |
| `agentic_ai/results` | Agent เขียนหลักฐานผลการทดสอบได้ |
| `agentic_ai/build` | Agent และ code generator เขียน build artifacts ได้ |
| `agentic_ai/reference` | ใช้เป็น fallback ไม่แก้ระหว่างกิจกรรม |
| `AGENTS.md` | ผู้จัด workshop เป็นผู้ดูแล ผู้เข้าร่วมไม่ต้องแก้ |

## วิธีอธิบายให้ผู้เข้าร่วมแบบสั้น

สามารถอธิบายได้ว่า repository นี้มีสามชั้น

1. **Workshop source** คือข้อมูล Exercise และโมเดลที่เตรียมไว้ เราอ่านและใช้งานแต่ไม่แก้ต้นฉบับ
2. **Agent workspace** คือ `agentic_ai/generated`, `results` และ `build` ซึ่ง Agent ใช้สร้างขั้นตอน หลักฐาน และ code โดยแยกออกจากต้นฉบับ
3. **Safety and guidance** คือ PDF, `README.md`, `AGENTS.md`, preflight และ reference scripts ซึ่งทำให้ผู้เข้าร่วมทุกคนทำ workflow เดียวกันและมี fallback เมื่อพบปัญหา

แนวทางนี้ทำให้การใช้ Agent โปร่งใส ผู้เข้าร่วมมองเห็น code ที่สร้าง ตรวจสอบผลแต่ละ Phase ได้ และสามารถย้อนกลับไปยังไฟล์ต้นฉบับได้ตลอดเวลา
