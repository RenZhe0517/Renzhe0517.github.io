/*
  Mysql第三次课
     order by 排序
         asc升序
         desc 降序
     group by 把表分组
     group by...having..分组并筛选符合
                        条件的组
     子查询
        查询语句里边嵌套查询语句
     连接
        把多张表连接成一张表,要注意
        一般连接有主外键关系的表
        连接分类：
        普通连接
           
        内连接
          inner join .. on...
          inner join用内连接方式连接
                    两张表
          on  后边写的是条件
        外连接（左连接与右连接）
            左连接
              left join..on...
              左边的表显示所有数据，
              右边的表只显示匹配上的
              数据
            右连接
              right join...on...
              右边的表显示全部数据
              左边的表只显示匹配上的
        全连接
            左右边都全部显示   
*/
CREATE DATABASE schooldb;
USE Schooldb;
#教师表
CREATE TABLE teacher(
   tid INT PRIMARY KEY AUTO_INCREMENT,
   tnam VARCHAR(20) NOT NULL,
   hiredate DATE,#入职日期
   sex VARCHAR(5) 
)
#班级信息表
CREATE TABLE ClassInfo(
   cid INT PRIMARY KEY AUTO_INCREMENT,
   cnam VARCHAR(20) NOT NULL,
   grid INT, #年级编号
   beginyear VARCHAR(20)
)
#学生信息表
CREATE TABLE StudentInfo(
   sid INT PRIMARY KEY AUTO_INCREMENT,
   snam VARCHAR(20) NOT NULL,
   sex VARCHAR(5),
   age INT,
   birthday DATE,
   cid INT, #班级编号
   beginyear VARCHAR(20),#入学日期
   stel VARCHAR(15),
   address VARCHAR(100),
   email VARCHAR(50)
)
#课程表
CREATE TABLE course(
   coid INT PRIMARY KEY AUTO_INCREMENT,
   cnam VARCHAR(50) NOT NULL,#课程名
   tid INT    #讲授老师编号 
)
#成绩表
CREATE TABLE score(
   scid INT PRIMARY KEY AUTO_INCREMENT,
   sid INT ,#学生学号
   coid INT, #课程编号
   score INT,
   remark VARCHAR(100) #备注 
)
#年级表
CREATE TABLE grade(
  gid INT PRIMARY KEY AUTO_INCREMENT,
  gnam VARCHAR(50), #年级名
  major VARCHAR(100) #专业
)
#一次性插入多条语句
INSERT INTO teacher(tnam,hiredate,sex)
VALUES('张三','2017-09-01','男'),
('李四','2018-07-02','男'),
('王五','2016-08-16','男');
INSERT INTO grade(gnam,major)
VALUES('18级','软信'),('19级','软信')
,('18级','移动'),('19级','移动');
INSERT INTO StudentInfo(snam,sex,age
,birthday,cid,beginyear,stel,address
,email) VALUES('崔一','男',18,'2001-07-05'
,1,'2018','18867890987',
'河南省许昌市','159078923@qq.com'),
('丁二','男',19,'2000-08-05'
,2,'2018','18967890987',
'河南省许昌市','156078923@qq.com'),
('丁三','男',20,'1999-09-05'
,3,'2018','18877890987',
'河南省郑州市','157078923@qq.com'),
('周三','女',17,'2002-06-05'
,4,'2019','18177890987',
'河南省洛阳市','157278923@qq.com');
INSERT INTO StudentInfo(snam,sex,age
,birthday,cid,beginyear,stel,address
,email) VALUES('周四','女',18,'2002-06-05'
,4,'2019','18177800087',
'河南省洛阳市','157279923@qq.com');
INSERT INTO ClassInfo(cnam,grid,
beginyear) VALUES('软信1',1,'2018')
,('移动1',2,'2018'),('软信1',3,'2019'),
('移动1',4,'2019');
INSERT INTO course(cnam,tid)
VALUES('计算机基础',1),('前端基础',2)
,('java基础',3),('js基础',3);
INSERT INTO score(sid,coid,score,remark)
VALUES(1,1,90,'无'),(1,2,75,'无'),
(1,3,59,'无'),(1,4,76,'无')
,(2,1,93,'无'),(2,2,77,'无'),
(2,3,66,'无'),(2,4,78,'无'),
(3,1,87,'无'),(3,2,55,'无'),
(3,3,76,'无'),
(4,1,88,'无'),(4,2,66,'无'),
(4,3,90,'无'),(4,4,76,'无');
#order by排序
#把StudentInfo表按年纪从小到大排序
SELECT * FROM StudentInfo ORDER BY 
    age ASC;
#把StudentInfo表按年纪从大到小排序
SELECT * FROM StudentInfo ORDER BY 
    age DESC;
#group by分组
#把某张表按照某个字段进行分组
#查询出每个学生的平均成绩，结果要
#显示的字段为，学生学号 平均成绩
SELECT sid,AVG(score) '平均成绩'
FROM score GROUP BY sid;
#group by ... havig..筛选出来符合条件
#的组
#查询出全部及格学生的平均成绩
SELECT sid,AVG(score) 'avg' FROM score
GROUP BY sid HAVING MIN(score)>60;
#查询出考试门数不够四门的学生学号
SELECT sid FROM score GROUP BY sid
    HAVING COUNT(*)<4;
#查询出“计算机基础”的成绩
SELECT coid,score FROM score WHERE
coid=(
SELECT coid FROM course 
             WHERE cnam='计算机基础');
#查询出每门课的平均成绩
SELECT coid,AVG(score)'平均成绩' FROM
               score GROUP BY coid; 
#查询出‘周三’学生的平均成绩
SELECT AVG(score) '平均成绩' FROM
               score WHERE sid=(
SELECT sid FROM StudentInfo 
               WHERE snam='周三');
#连接
#普通连接
SELECT * FROM StudentInfo s,score c
                      WHERE 
                      s.sid=c.sid;
#查询出每个人的平均成绩，要显示的
#字段为，姓名 平均成绩
SELECT snam,AVG(score) FROM 
             StudentInfo s,score c
             WHERE 
             s.sid=c.sid
             GROUP BY s.sid;
#内连接
SELECT * FROM StudentInfo s 
              INNER JOIN
              score c 
              ON
              s.sid=c.sid;
SELECT snam,AVG(score) FROM 
             StudentInfo s
             INNER JOIN             
             score c
             ON 
             s.sid=c.sid
             GROUP BY s.sid;
             
#左连接
SELECT * FROM StudentInfo s 
              LEFT JOIN
              score c
              ON
              s.sid=c.sid;
#查询出有不及格成绩的学生信息，
#缺考算不及格
SELECT * FROM StudentInfo WHERE sid 
IN(
SELECT sid FROM score
          GROUP BY sid 
          HAVING MIN(score)<60
UNION
SELECT sid FROM score 
             GROUP BY sid
             HAVING 
             COUNT(*)<
             (SELECT COUNT(*) FROM 
               course));

          










