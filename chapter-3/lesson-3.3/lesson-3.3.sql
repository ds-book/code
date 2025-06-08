-- =============== --
-- Создание Таблиц --
-- =============== --

-- Создадим таблицу с полями
CREATE TABLE public.patient (
	id serial NOT NULL,
	last_name varchar(25) NOT NULL,
	first_name varchar(25) NOT NULL,
	email email NOT NULL,
	center_id int4 NOT NULL,
	birth_date date NOT NULL,
	arrival_date date NOT NULL,
	discharge_date date NULL,
	age_years int NULL,
	hospitalization_days int NULL,
	created_date timestamp NOT NULL DEFAULT now(),
	updated_date timestamp NOT NULL DEFAULT now()
);

-- Добавим столбец с полом с нашим кастомным типом
ALTER TABLE public.patient  ADD column gender gender NOT NULL DEFAULT 'неизвестно'::gender;

-- ======================== --
-- Заполним таблицу данными --
-- ======================== --
-- Данные инструкции созданы с помощью сервиса https://www.mockaroo.com/
-- Получим текущий стиль даты
SHOW datestyle; --ISO, DMY
-- Установим новый стиль дат, чтобы можно было записать данные
SET datestyle = "ISO, MDY";
-- Запишем данные
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Donall', 'Hainey`', 'dhainey0@blog.com', 'мужской', 283, '3/19/1992', '10/24/2022', '5/6/2022', 30.6186976471, -171.4408449074);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Holden', 'Rikel', 'hrikel1@yolasite.com', 'мужской', 319, '5/16/1993', '10/6/2022', '7/11/2022', 29.411533105, -87.6986574074);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Thelma', 'Sutherden', 'tsutherden2@cbc.ca', 'женский', 302, '5/5/1991', '4/17/2022', '6/25/2022', 30.9723567352, 68.8052777778);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Dilly', 'Kealey', 'dkealey3@simplemachines.org', 'мужской', 40, '6/16/1990', '9/5/2022', '11/8/2022', 32.2433007357, 64.4304513889);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Margery', 'Vasyagin', 'mvasyagin4@npr.org', 'женский', 408, '12/30/1994', '3/11/2022', '6/12/2022', 27.2155430302, 92.6382291667);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Jenica', 'Simonassi', 'jsimonassi5@youtube.com', 'женский', 152, '9/5/1992', '8/30/2022', '6/20/2022', 30.0017853247, -70.9885300926);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Vernon', 'Southerns', 'vsoutherns6@soundcloud.com', 'мужской', 499, '7/30/1990', '6/12/2022', '3/21/2022', 31.8893591768, -82.5118865741);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Wait', 'Northidge', 'wnorthidge7@xrea.com', 'мужской', 205, '3/20/1990', '10/6/2022', '9/2/2022', 32.5721824264, -34.9328819444);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Emilee', 'Keats', 'ekeats8@networkadvertising.org', 'женский', 55, '5/15/1992', '8/8/2022', '10/14/2022', 30.2512933156, 67.1665856481);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Milo', 'Perrelli', 'mperrelli9@harvard.edu', 'мужской', 485, '4/6/1993', '3/23/2022', '5/31/2022', 28.982530156, 68.5491666667);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Robbie', 'O''Flynn', 'roflynna@engadget.com', 'женский', 214, '10/12/1992', '3/27/2022', '6/6/2022', 29.4755097032, 70.5121875);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Jilly', 'Dochon', 'jdochonb@usatoday.com', 'женский', 365, '12/31/1992', '9/23/2022', '4/4/2022', 29.7478638382, -172.2137615741);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Clarette', 'Follis', 'cfollisc@webeden.co.uk', 'женский', 114, '10/9/1993', '8/21/2022', '10/21/2022', 28.8856193557, 61.0188078704);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Tobye', 'Joscelyn', 'tjoscelynd@nih.gov', 'женский', 204, '6/21/1992', '10/18/2022', '9/4/2022', 30.3460288876, -44.2717476852);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Rowland', 'Pottery', 'rpotterye@usgs.gov', 'мужской', 189, '12/21/1990', '6/15/2022', '7/16/2022', 31.5035552702, 30.6581481481);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Alexei', 'Elmhurst', 'aelmhurstf@arstechnica.com', 'мужской', 321, '9/11/1995', '9/4/2022', '10/9/2022', 26.9980545408, 35.1906134259);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Marna', 'O''Hartagan', 'mohartagang@blogtalkradio.com', 'женский', 400, '3/23/1994', '8/1/2022', '7/17/2022', 28.3766393011, -14.6936574074);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Ced', 'Von Welden', 'cvonweldenh@hibu.com', 'мужской', 8, '4/22/1991', '4/8/2022', '2/17/2022', 30.9813271182, -49.6584490741);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Elmer', 'Mattin', 'emattini@networkadvertising.org', 'мужской', 37, '11/6/1993', '4/9/2022', '11/11/2022', 28.4413177638, 216.0805439815);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Valry', 'Farre', 'vfarrej@webmd.com', 'женский', 228, '10/11/1994', '10/4/2022', '3/3/2022', 27.9996606101, -214.3649884259);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Lainey', 'Koene', 'lkoenek@jugem.jp', 'женский', 32, '6/14/1992', '4/29/2022', '11/6/2022', 29.8928936136, 191.0752430556);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Hastings', 'Kegan', 'hkeganl@slideshare.net', 'мужской', 68, '11/15/1993', '7/13/2022', '8/31/2022', 28.6769528475, 48.6377314815);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Cecil', 'Tunsley', 'ctunsleym@umn.edu', 'женский', 223, '7/18/1991', '10/16/2022', '8/12/2022', 31.2696081938, -65.6822916667);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Maryrose', 'Rogge', 'mroggen@behance.net', 'женский', 446, '12/29/1992', '2/22/2022', '9/9/2022', 29.167650463, 199.7552546296);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Lenci', 'Harnetty', 'lharnettyo@fotki.com', 'мужской', 93, '1/1/1991', '11/17/2022', '3/21/2022', 31.8982151826, -241.3021759259);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Giorgia', 'Evenett', 'gevenettp@miibeian.gov.cn', 'женский', 244, '10/21/1991', '10/15/2022', '5/21/2022', 31.0060230847, -146.9623148148);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Karry', 'Hatherley', 'khatherleyq@latimes.com', 'женский', 133, '1/8/1993', '7/17/2022', '8/23/2022', 29.539411276, 36.5075810185);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Ingamar', 'Banstead', 'ibansteadr@edublogs.org', 'мужской', 341, '7/8/1990', '4/5/2022', '11/18/2022', 31.7642052892, 227.6757060185);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Biddy', 'Chatband', 'bchatbands@360.cn', 'женский', 12, '2/12/1993', '10/17/2022', '5/19/2022', 29.6955219115, -151.2013425926);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Duffie', 'Smullin', 'dsmullint@weather.com', 'мужской', 456, '6/5/1994', '6/18/2022', '3/13/2022', 28.0546616565, -96.071400463);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Mitzi', 'Ibbeson', 'mibbesonu@stanford.edu', 'женский', 98, '3/7/1993', '8/18/2022', '6/20/2022', 29.4676692986, -58.7801041667);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Dena', 'Gages', 'dgagesv@freewebs.com', 'женский', 30, '10/19/1995', '10/29/2022', '7/21/2022', 27.047610033, -99.8178240741);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Annabel', 'Westlake', 'awestlakew@xinhuanet.com', 'женский', 97, '2/29/1992', '11/9/2022', '7/3/2022', 30.7156589612, -128.9594907407);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Mallissa', 'Rebanks', 'mrebanksx@privacy.gov.au', 'женский', 75, '11/16/1990', '8/1/2022', '9/12/2022', 31.7291354325, 42.3320717593);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Jerri', 'Penkman', 'jpenkmany@eventbrite.com', 'мужской', 50, '10/18/1992', '4/29/2022', '5/17/2022', 29.5488005454, 18.1423958333);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Morgun', 'Gillanders', 'mgillandersz@va.gov', 'мужской', 315, '5/26/1994', '5/8/2022', '11/19/2022', 27.9677680429, 195.4353240741);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Sue', 'Wallice', 'swallice10@ning.com', 'женский', 345, '10/25/1994', '9/24/2022', '4/12/2022', 27.9332337646, -164.8091435185);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Neile', 'Tremontana', 'ntremontana11@shinystat.com', 'женский', 375, '10/19/1991', '10/30/2022', '10/25/2022', 31.0521485921, -5.7692013889);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Marchall', 'Henriet', 'mhenriet12@infoseek.co.jp', 'мужской', 272, '3/24/1993', '10/16/2022', '8/31/2022', 29.5824765348, -45.5678009259);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Duncan', 'Edser', 'dedser13@admin.ch', 'мужской', 283, '1/9/1995', '10/30/2022', '9/14/2022', 27.8241067669, -46.1739699074);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Kendre', 'Salandino', 'ksalandino14@earthlink.net', 'женский', 244, '5/18/1995', '11/23/2022', '7/18/2022', 27.5347218417, -127.974525463);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Jaquenetta', 'Malthouse', 'jmalthouse15@ted.com', 'женский', 59, '9/21/1990', '5/9/2022', '4/6/2022', 31.6520745497, -32.3208101852);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Bobby', 'Kellock', 'bkellock16@goo.ne.jp', 'женский', 281, '7/22/1993', '7/23/2022', '4/13/2022', 29.0228040335, -101.1596990741);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Kellen', 'Goss', 'kgoss17@furl.net', 'мужской', 254, '7/27/1990', '5/13/2022', '2/1/2022', 31.8170873288, -100.5771296296);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Kacie', 'Evers', 'kevers18@blogger.com', 'женский', 377, '3/27/1992', '11/20/2022', '9/1/2022', 30.6697608765, -79.4195023148);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Danielle', 'Philippeaux', 'dphilippeaux19@cdbaby.com', 'женский', 219, '5/12/1992', '4/14/2022', '8/10/2022', 29.943013445, 118.2042476852);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Trenton', 'Burgyn', 'tburgyn1a@acquirethisname.com', 'мужской', 160, '4/23/1993', '11/10/2022', '7/20/2022', 29.5719852232, -113.1472106481);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Nicky', 'Shewsmith', 'nshewsmith1b@stanford.edu', 'мужской', 334, '2/1/1995', '3/2/2022', '11/25/2022', 27.096910071, 268.4736458333);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Imelda', 'Plues', 'iplues1c@hexun.com', 'женский', 64, '2/1/1995', '4/10/2022', '9/8/2022', 27.2066377156, 150.717349537);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Abramo', 'Lottrington', 'alottrington1d@slate.com', 'мужской', 416, '12/6/1991', '5/1/2022', '10/2/2022', 30.4197063039, 154.554375);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Amitie', 'Fassam', 'afassam1e@opensource.org', 'женский', 387, '11/3/1990', '10/1/2022', '5/30/2022', 31.9299729833, -123.9929398148);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Kara-lynn', 'Gilkes', 'kgilkes1f@howstuffworks.com', 'женский', 406, '12/20/1992', '7/29/2022', '6/21/2022', 29.6251873732, -38.063587963);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Reginald', 'Garred', 'rgarred1g@qq.com', 'мужской', 28, '4/5/1992', '2/28/2022', '7/25/2022', 29.9202103945, 146.8094560185);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Carmine', 'Panks', 'cpanks1h@infoseek.co.jp', 'мужской', 464, '6/2/1994', '10/27/2022', '4/12/2022', 28.4208834665, -197.6411342593);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Berri', 'Airey', 'bairey1i@cpanel.net', 'женский', 27, '1/5/1995', '5/8/2022', '2/26/2022', 27.3543337773, -70.8549421296);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Riccardo', 'Balle', 'rballe1j@diigo.com', 'мужской', 5, '3/17/1995', '4/17/2022', '8/6/2022', 27.1039323313, 111.0262152778);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Andrea', 'Polendine', 'apolendine1k@printfriendly.com', 'мужской', 490, '3/9/1995', '3/24/2022', '9/25/2022', 27.0604577943, 185.1985069444);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Yehudit', 'Gleadle', 'ygleadle1l@usa.gov', 'мужской', 143, '1/2/1994', '2/17/2022', '2/12/2022', 28.1470371956, -5.6371064815);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Bengt', 'Bolzmann', 'bbolzmann1m@ed.gov', 'мужской', 292, '8/9/1994', '8/24/2022', '8/25/2022', 28.0599212646, 0.8553009259);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Clemmie', 'Entwistle', 'centwistle1n@un.org', 'мужской', 8, '3/30/1991', '7/21/2022', '8/8/2022', 31.3337905251, 17.8155555556);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Charleen', 'Cornborough', 'ccornborough1o@people.com.cn', 'женский', 213, '3/15/1994', '8/5/2022', '9/2/2022', 28.4099911847, 27.8917939815);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Cristie', 'Copson', 'ccopson1p@usnews.com', 'женский', 209, '3/13/1991', '5/28/2022', '9/5/2022', 31.2305071347, 99.0786111111);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Dean', 'Strahan', 'dstrahan1q@slideshare.net', 'мужской', 96, '1/11/1991', '10/25/2022', '9/19/2022', 31.8085152207, -35.7434837963);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Massimiliano', 'Scarff', 'mscarff1r@time.com', 'мужской', 145, '9/12/1995', '11/12/2022', '8/22/2022', 27.1862671233, -81.4638541667);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Bastien', 'Baroux', 'bbaroux1s@cloudflare.com', 'мужской', 208, '6/8/1992', '10/22/2022', '6/23/2022', 30.3915148402, -121.6997337963);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Jobina', 'Blamey', 'jblamey1t@hugedomains.com', 'женский', 491, '10/8/1990', '3/19/2022', '5/31/2022', 31.4647692796, 72.8236805556);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Benedikt', 'Ransfield', 'bransfield1u@de.vu', 'мужской', 31, '6/18/1993', '6/18/2022', '2/8/2022', 29.0199293506, -130.7126851852);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Mikel', 'Kilcullen', 'mkilcullen1v@microsoft.com', 'мужской', 421, '12/13/1992', '7/16/2022', '9/23/2022', 29.6078311771, 68.7499884259);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Addison', 'Fricker', 'africker1w@blinklist.com', 'мужской', 239, '5/13/1993', '8/28/2022', '5/27/2022', 29.3124653729, -93.406712963);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Lewie', 'Amaya', 'lamaya1x@google.it', 'мужской', 428, '4/12/1991', '4/19/2022', '11/11/2022', 31.039997273, 205.8551967593);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Clemmy', 'Marsters', 'cmarsters1y@apache.org', 'мужской', 379, '6/15/1990', '5/1/2022', '4/26/2022', 31.8983365994, -5.0139699074);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Patsy', 'Broggelli', 'pbroggelli1z@wp.com', 'мужской', 427, '5/5/1991', '7/30/2022', '4/12/2022', 31.2578875254, -109.4103009259);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Augustine', 'Fabbri', 'afabbri20@baidu.com', 'женский', 279, '10/10/1990', '10/7/2022', '2/18/2022', 32.014843861, -230.9899189815);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Stesha', 'Battams', 'sbattams21@amazon.co.jp', 'женский', 419, '9/16/1990', '8/18/2022', '10/18/2022', 31.9438239789, 60.7771759259);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Maison', 'Vischi', 'mvischi22@altervista.org', 'мужской', 209, '1/2/1995', '7/18/2022', '7/21/2022', 27.5601486555, 2.7904976852);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Miltie', 'Fiddyment', 'mfiddyment23@wordpress.org', 'мужской', 292, '9/27/1991', '3/4/2022', '5/20/2022', 30.454829655, 76.7216203704);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Cinda', 'Poor', 'cpoor24@google.ca', 'женский', 225, '8/14/1993', '10/13/2022', '6/19/2022', 29.1841863902, -116.0912268519);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Domingo', 'Frewer', 'dfrewer25@printfriendly.com', 'мужской', 19, '8/3/1990', '5/17/2022', '3/26/2022', 31.8099178399, -52.3016319444);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Nolana', 'Pentony', 'npentony26@liveinternet.ru', 'женский', 78, '9/21/1993', '3/1/2022', '3/23/2022', 28.4602617009, 21.8711342593);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Florry', 'Chopping', 'fchopping27@studiopress.com', 'женский', 197, '5/21/1993', '6/20/2022', '3/25/2022', 29.1023995434, -87.4053587963);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Kira', 'Forde', 'kforde28@goo.ne.jp', 'женский', 469, '12/31/1990', '11/2/2022', '10/19/2022', 31.8603379313, -14.3182060185);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Nobe', 'Leyes', 'nleyes29@unblog.fr', 'мужской', 88, '6/24/1994', '11/25/2022', '3/2/2022', 28.4393243278, -267.3928819444);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Valli', 'Comrie', 'vcomrie2a@cnn.com', 'женский', 92, '8/31/1990', '9/25/2022', '3/15/2022', 32.0906503361, -193.8599768519);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Cherianne', 'Lorand', 'clorand2b@lycos.com', 'женский', 38, '10/2/1992', '11/14/2022', '11/3/2022', 30.1367054477, -11.1912152778);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Josias', 'Benditt', 'jbenditt2c@prlog.org', 'мужской', 381, '1/26/1994', '3/2/2022', '3/12/2022', 28.1144672438, 10.3076736111);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Westbrook', 'Fyldes', 'wfyldes2d@seattletimes.com', 'мужской', 349, '4/28/1991', '7/16/2022', '2/18/2022', 31.2386289954, -148.1040509259);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Rabbi', 'McMeyler', 'rmcmeyler2e@bbc.co.uk', 'мужской', 82, '9/1/1994', '5/24/2022', '10/14/2022', 27.7461625127, 143.2027893519);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Marney', 'Wingatt', 'mwingatt2f@slideshare.net', 'женский', 13, '1/6/1994', '7/2/2022', '5/11/2022', 28.5042170218, -51.1761574074);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Darda', 'Yeoman', 'dyeoman2g@google.co.jp', 'женский', 411, '3/6/1994', '5/16/2022', '3/29/2022', 28.2136072108, -48.4085185185);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Marty', 'De Bruyne', 'mdebruyne2h@fema.gov', 'женский', 236, '2/23/1994', '11/6/2022', '6/17/2022', 28.7199464739, -141.4842476852);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Cyrillus', 'Allcorn', 'callcorn2i@prlog.org', 'мужской', 229, '12/13/1994', '6/22/2022', '5/15/2022', 27.5420690322, -37.7418865741);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Abie', 'Syfax', 'asyfax2j@ycombinator.com', 'мужской', 187, '11/30/1992', '7/25/2022', '2/5/2022', 29.6686700596, -170.5302893519);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Darcee', 'Chell', 'dchell2k@nps.gov', 'женский', 479, '2/8/1992', '7/24/2022', '10/12/2022', 30.4780710934, 79.5827893519);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Concordia', 'Buzin', 'cbuzin2l@usatoday.com', 'женский', 114, '2/17/1990', '7/23/2022', '9/11/2022', 32.4496591832, 50.365162037);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Son', 'Eversley', 'seversley2m@phpbb.com', 'мужской', 272, '5/15/1993', '5/20/2022', '5/24/2022', 29.0319226915, 4.1238078704);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Mark', 'Escalero', 'mescalero2n@huffingtonpost.com', 'мужской', 260, '1/7/1993', '6/23/2022', '2/22/2022', 29.4762967085, -120.8501273148);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Val', 'Dominighi', 'vdominighi2o@shutterfly.com', 'женский', 202, '9/23/1992', '3/12/2022', '8/25/2022', 29.485423738, 165.8755555556);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Terrie', 'Bellee', 'tbellee2p@about.com', 'женский', 317, '10/16/1995', '10/25/2022', '8/2/2022', 27.0428254376, -84.1036921296);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Napoleon', 'Yearby', 'nyearby2q@nyu.edu', 'мужской', 173, '10/12/1994', '4/28/2022', '5/24/2022', 27.5615900875, 26.888599537);
insert into patient (first_name, last_name, email, gender, center_id, birth_date, arrival_date, discharge_date, age_years, hospitalization_days) values ('Torrey', 'Corbridge', 'tcorbridge2r@livejournal.com', 'мужской', 313, '9/29/1993', '5/20/2022', '5/25/2022', 28.6588640284, 4.2474189815);
--- Установим стиль даты обратно
SET datestyle = "ISO, DMY";

-- Поправим некорретные данные
UPDATE public.patient
  SET arrival_date = discharge_date,
      discharge_date = arrival_date,
      hospitalization_days = abs(hospitalization_days)
   WHERE hospitalization_days < 0;

-- Поправим типы столбцов, чтобы такое не повторялось
ALTER TABLE public.patient ALTER COLUMN age_years TYPE positiveint;
ALTER TABLE public.patient ALTER COLUMN hospitalization_days TYPE positiveint;

-- ==================== --
-- Создание Ограничений --
-- ==================== --
-- https://postgrespro.ru/docs/postgrespro/14/ddl-constraints

-- Добавим первичный ключ
ALTER TABLE public.patient ADD CONSTRAINT patient_pkey PRIMARY KEY (id);

-- Дополнительные проверки
ALTER TABLE public.patient ADD CONSTRAINT patient_email_unique UNIQUE (email);
ALTER TABLE public.patient ADD CONSTRAINT patient_bdate CHECK(birth_date <= now());
ALTER TABLE public.patient ADD CONSTRAINT patient_hostdates CHECK(arrival_date <= discharge_date);

-- Индекс для поиска по email
CREATE UNIQUE INDEX patient_email_uniq_idx ON public.patient (email) INCLUDE (last_name, first_name);
CREATE UNIQUE INDEX patient_uniq_idx ON public.patient (last_name, first_name, birth_date);

-- Внешние ключи
ALTER TABLE public.patient ADD CONSTRAINT patient_fk_centers FOREIGN KEY (center_id)
REFERENCES public.centers(id) ON DELETE NO ACTION ON UPDATE CASCADE;

-- С помощью выражений ON DELETE и ON UPDATE можно установить действия,
-- которые выполняются соответственно при удалении и изменении связанной строки из главной таблицы.
-- Для установки подобного действия можно использовать следующие опции:

-- CASCADE: автоматически удаляет или изменяет строки из зависимой таблицы
--          при удалении или изменении связанных строк в главной таблице.

-- RESTRICT: предотвращает какие-либо действия в зависимой таблице
--           при удалении или изменении связанных строк в главной таблице.

-- NO ACTION: действие по умолчанию, предотвращает какие-либо действия в зависимой таблице
--            при удалении или изменении связанных строк в главной таблице. И генерирует ошибку.
--            В отличие от RESTRICT выполняет отложенную проверку на связанность между таблицами.

-- SET NULL: при удалении связанной строки из главной таблицы
--           устанавливает для столбца внешнего ключа значение NULL.

-- SET DEFAULT: при удалении связанной строки из главной таблицы
--              устанавливает для столбца внешнего ключа значение по умолчанию,
--              которое задается с помощью атрибуты DEFAULT.
--              Если для столбца не задано значение по умолчанию,
--              то в качестве него применяется значение NULL.

-- Данное ограничение не позволяет добавить центр, которого нет в справочнике - таблице centers
INSERT INTO public.patient
(last_name, first_name, email, center_id, birth_date, arrival_date, discharge_date)
VALUES('test', 'test', 'test2@example.com', 1000, '2000-02-16', '2022-11-10', '2022-11-22');

-- Посмотрим на пациентов из Центра 38
SELECT * FROM patient p WHERE center_id = 38;
-- Удалим Центр 38
DELETE FROM centers WHERE id = 38;
-- Здесь ошибка потому что таблица centers связана не только с таблицей patient но и pat

-- Найдем центры которые есть только в patient и отсутствуют в pat
select distinct center_id from patient except select center_id from pat order by center_id;

-- Посмотрим на пациентов из Центра 98
SELECT * FROM patient p WHERE center_id = 98;
-- Удалим Центр 98
DELETE FROM centers WHERE id = 98;
-- Мы не сможем удалить, потому что ограничение  ON DELETE NO ACTION не позволяет этого сделать

-- Теперь изменим тип связи
-- Удалим связь по внешнему ключу
ALTER TABLE public.patient DROP CONSTRAINT patient_fk_centers;
-- Создадим заново уже с каскадным удалением связанных записей
ALTER TABLE public.patient ADD CONSTRAINT patient_fk_centers FOREIGN KEY (center_id)
REFERENCES public.centers(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Посмотрим на пациентов из Центра 98
SELECT * FROM patient p WHERE center_id = 98;
-- Удалим Центр 98
DELETE FROM centers WHERE id = 98;
-- Посмотрим на пациентов из 98. Они удалились как связанные записи с центром 98 благодаря ON DELETE CASCADE
SELECT * FROM patient p WHERE center_id = 98;

-- ================== --
-- Создание Триггеров --
-- ================== --
-- https://postgrespro.ru/docs/postgrespro/14/sql-createtrigger
-- https://postgrespro.ru/docs/postgrespro/14/plpgsql-trigger

-- Триггер на перерасчет возраста и дней госпитализации при вставке новой записи
CREATE TRIGGER trg_calc_age_on_insert
	BEFORE INSERT ON public.patient
    FOR EACH ROW
    EXECUTE FUNCTION fns_calc_patient_dates_insert();
-- Триггер обязательно использует функцию, поэтому сначала надо ее создать

   -- Функция для перерасчета возраста и дней госпитализации
CREATE OR REPLACE FUNCTION fns_calc_patient_dates_insert()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	NEW.age_years := date_part('year', AGE( new.arrival_date::date, new.birth_date::date));
    IF (NEW.discharge_date IS NOT NULL)
    THEN
		NEW.hospitalization_days := new.discharge_date::date - new.arrival_date::date;
   	ELSE
   		NEW.hospitalization_days := NULL;
   	END IF;

   RETURN NEW;
END;
$$

-- После создания фукнции создадим триггер
CREATE TRIGGER trg_calc_age_on_insert
	BEFORE INSERT ON public.patient
    FOR EACH ROW
    EXECUTE FUNCTION fns_calc_patient_dates_insert();

-- Вставим новую строку
INSERT INTO public.patient
(last_name, first_name, email, center_id, birth_date, arrival_date, discharge_date)
VALUES('test', 'test', 'test2@example.com', 1, '2000-02-16', '2022-11-10', '2022-11-22');

-- Проверим работу триггера на вставку
SELECT * FROM public.patient ORDER BY id DESC;

-- Сделаем триггер на обновление данных - перерасчет возраста и дней госпитализации при изменении дат
CREATE OR REPLACE FUNCTION fns_calc_patient_dates_on_update()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF (NEW.birth_date <> OLD.birth_date OR NEW.arrival_date <> OLD.arrival_date)
	THEN
		NEW.age_years := date_part('year', AGE( new.arrival_date::date, new.birth_date::date));
	END IF;

	IF (NEW.discharge_date <> OLD.discharge_date OR NEW.arrival_date <> OLD.arrival_date)
	THEN
		NEW.hospitalization_days := new.discharge_date::date - new.arrival_date::date;
	END IF;

	NEW.updated_date := now();

	RETURN NEW;
END;
$$

CREATE TRIGGER trg_calc_age_on_update
	BEFORE UPDATE ON public.patient
    FOR EACH ROW
    EXECUTE FUNCTION fns_calc_patient_dates_on_update();

-- Попробуем обновить - изменим дату рождения
UPDATE public.patient SET birth_date = '1998-06-24' WHERE id = 6;
-- Проверим работу триггера - возраст пересчитался
SELECT * FROM public.patient WHERE id = 6;

-- Удалим последнюю запись
DELETE FROM patient WHERE id > 100;

-- Снова вставим
INSERT INTO public.patient
(last_name, first_name, email, center_id, birth_date, arrival_date, discharge_date)
VALUES('test3', 'test3', 'test3@example.com', 1, '2000-02-16', '2022-11-10', '2022-11-22');

-- Посмотрим результат
SELECT * FROM public.patient p ORDER BY ID DESC LIMIT 10;

-- Создадим триггер на перерасчет счетчика
-- Функция, которая устанавливает текущее значение последовательности равное максимальному id таблицы patient
CREATE OR REPLACE FUNCTION fns_recalc_patient_id()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	PERFORM setval('patient_id_seq', (SELECT max(id) FROM public.patient));
	RETURN NULL;
END;
$$

-- Триггер, запускающий эту функцию после удаления записи
CREATE TRIGGER trg_recalc_patient_id_on_delete
	AFTER DELETE ON public.patient
    FOR EACH STATEMENT
    EXECUTE FUNCTION fns_recalc_patient_id();

-- Повторим еще раз
DELETE FROM patient WHERE id > 100;
-- Снова вставим
INSERT INTO public.patient (last_name, first_name, email, center_id, birth_date, arrival_date, discharge_date)
VALUES('test4', 'test4', 'test4@example.com', 1, '2000-02-16', '2022-11-10', '2022-11-22');

-- Посмотрим результат
SELECT * FROM public.patient p ORDER BY ID DESC LIMIT 10;

-- Триггеры можно отключать DISABLE
ALTER TABLE public.patient DISABLE TRIGGER trg_recalc_patient_id_on_delete;

DELETE FROM patient WHERE id > 100;

INSERT INTO public.patient (last_name, first_name, email, center_id, birth_date, arrival_date, discharge_date)
VALUES('test', 'test', 'test2@example.com', 1, '2000-02-16', '2022-11-10', '2022-11-22');

SELECT * FROM public.patient p ORDER BY ID DESC LIMIT 10;

-- Включим триггер обратно
ALTER TABLE public.patient ENABLE TRIGGER trg_recalc_patient_id_on_delete;

-- ====== --
-- INSERT --
-- ====== --

-- Посмотрим внимательно на таблицу с центрами.
-- Названия городов дублируются
SELECT DISTINCT city_name, count(1) as amount
FROM public.centers c
GROUP BY city_name
ORDER BY amount DESC ;

-- Создадим таблицу для хранения городов
CREATE TABLE public.cities (
	id serial NOT NULL PRIMARY KEY,
	name varchar(300) NOT NULL
);

-- Заполним таблицу городами
INSERT INTO cities (name) SELECT DISTINCT city_name FROM centers ORDER BY city_name;

-- Теперь обновим таблицу centers, чтобы у нее были внешние ключи на таблицу cities
ALTER TABLE centers ADD COLUMN city_id int4 NULL;

ALTER TABLE centers ADD CONSTRAINT center_fk_cities FOREIGN KEY (city_id)
REFERENCES public.cities(id) ON DELETE NO ACTION ON UPDATE CASCADE;

-- Заполним внешние ключи данными
UPDATE public.centers
SET city_id = public.cities.id
FROM public.cities
WHERE public.centers.city_name = public.cities."name" ;

-- Теперь можно поставить ограничение, чтобы внешний ключ не был пустым
ALTER TABLE public.centers ALTER COLUMN city_id SET NOT NULL;

-- Сделать столбец с названиями центров
ALTER TABLE public.centers ADD COLUMN center_name varchar(300) NULL;

-- Переписать названия центров
UPDATE public.centers SET center_name = 'Центр № ' || id ;

-- Удалить ненужный столбец city_name
ALTER TABLE public.centers DROP COLUMN city_name;

SELECT * FROM public.centers c ;


-- ====================== --
-- Создание Представлений --
-- ====================== --

-- Создадим представление
CREATE VIEW public.vw_city_top_5 AS
SELECT
	c2.name as city_name,
	count(*) as patient_count,
	min(p.hospitalization_days) as min_days,
	round(avg(p.hospitalization_days)) as avg_days,
	max(p.hospitalization_days) as max_days
FROM public.patient p
	LEFT JOIN public.centers c ON c.id = p.center_id
	LEFT JOIN public.cities c2 ON c2.id = c.city_id
GROUP BY c2."name"
HAVING count(*)  > 1
ORDER BY patient_count DESC, avg_days ASC
LIMIT 5;

-- Посмотрим на наше представление
SELECT city_name, patient_count, min_days, avg_days, max_days
FROM public.vw_city_top_5;

-- Данное представление не хранит в себе данные. Оно только содержит инструкции запроса.
-- Если мы изменим данные в таблицах, на которые оно ссылается, то результат тоже изменится.

SELECT id FROM centers c WHERE city_id IN (select id from cities c2 where name = 'Санкт-Петербург');

-- Перепишем всех пациентов из Санкт-Петербурга в один центр (Москву)
UPDATE public.patient
SET center_id = 109
WHERE center_id IN (
	SELECT id
	FROM centers c
	WHERE city_id IN (
		select id from cities c2 where name = 'Санкт-Петербург'
	)
)

-- Посмотрим представление
SELECT city_name, patient_count, min_days, avg_days, max_days
FROM public.vw_city_top_5;

-- Попробуем переименовать наше представление
ALTER VIEW public.vw_city_top_5 RENAME TO vw_city_top_5_by_patients;

SELECT * FROM public.vw_city_top_5_by_patients;

-- Попробуем переименовать столбец
ALTER VIEW public.vw_city_top_5_by_patients RENAME COLUMN city_name TO city;
SELECT * FROM public.vw_city_top_5_by_patients;

-- Но если требуется изменить сам запрос внутри представления

CREATE OR REPLACE VIEW public.vw_city_top_5_by_patients
AS SELECT c2.name AS city,
    count(*) AS patient_count,
    min(p.hospitalization_days::integer) AS min_days,
    round(avg(p.hospitalization_days::integer)) AS avg_days,
    max(p.hospitalization_days::integer) AS max_days
   FROM patient p
     LEFT JOIN centers c ON c.id = p.center_id
     LEFT JOIN cities c2 ON c2.id = c.city_id
  GROUP BY c2.name
 HAVING count(*) > 1
  ORDER BY (count(*)) DESC, (round(avg(p.hospitalization_days::integer)))
 LIMIT 10;

SELECT * FROM public.vw_city_top_5_by_patients;

-- Но при этом сама структура представления должна сохраняться
-- Допустим мы попробуем так переименовать столбец и удалить ненужный
CREATE OR REPLACE VIEW public.vw_city_top_5_by_patients
AS SELECT c2.name AS city_name,
	count(*) AS patient_count,
    min(p.hospitalization_days::integer) AS min_days,
    round(avg(p.hospitalization_days::integer)) AS avg_days,
    max(p.hospitalization_days::integer) AS max_days
   FROM patient p
     LEFT JOIN centers c ON c.id = p.center_id
     LEFT JOIN cities c2 ON c2.id = c.city_id
  GROUP BY c2.name
 HAVING count(*) > 1
  ORDER BY (count(*)) DESC, (round(avg(p.hospitalization_days::integer)))
 LIMIT 10;

-- Удалим и создадим заново
DROP VIEW public.vw_city_top_5_by_patients;

CREATE OR REPLACE VIEW public.vw_city_top_5_by_patients
AS SELECT c2.name AS city_name,
	count(*) AS patient_count,
    min(p.hospitalization_days::integer) AS min_days,
    round(avg(p.hospitalization_days::integer)) AS avg_days,
    max(p.hospitalization_days::integer) AS max_days
   FROM patient p
     LEFT JOIN centers c ON c.id = p.center_id
     LEFT JOIN cities c2 ON c2.id = c.city_id
  GROUP BY c2.name
 HAVING count(*) > 1
  ORDER BY (count(*)) DESC, (round(avg(p.hospitalization_days::integer)))
 LIMIT 10;


SELECT * FROM public.vw_city_top_5_by_patients;
