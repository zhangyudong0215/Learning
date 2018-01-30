library(ggplot2)
set.seed(1410)
dsmall <- diamonds[sample(nrow(diamonds), 100), ]
dsmall
qplot(carat, price, data = diamonds)
qplot(log(carat), log(price), data = diamonds)
qplot(carat, x*y*z, data = diamonds)
str(diamonds)
qplot(carat, price, data = dsmall, colour = color)
qplot(carat, price, data = dsmall, shape = cut)
qplot(carat, price, data = dsmall, colour = color, shape = cut)
qplot(carat, price, data = diamonds, alpha = I(1/10))
qplot(carat, price, data = diamonds, alpha = I(1/100))
qplot(carat, price, data = diamonds, alpha = I(1/200))
qplot(carat, price, data = dsmall, geom = c('point', 'smooth'))
qplot(carat, price, data = diamonds, geom = c('point', 'smooth'))
qplot(carat, price, data = dsmall, geom = c('point', 'smooth'), se = FALSE)
qplot(carat, price, data = dsmall, geom = c('point', 'smooth'), span = 0.2)
qplot(carat, price, data = dsmall, geom = c('point', 'smooth'), span = 1)
library(mgcv)
qplot(carat, price, data = dsmall, geom = c('point', 'smooth'), method = 'gam', formula = y~s(x))
qplot(carat, price, data = dsmall, geom = c('point', 'smooth'), method = 'gam', formula = y~s(x, bs = 'cs'))
?qplot 
library(splines)
qplot(carat, price, data = dsmall, geom = c('point', 'smooth'), method = 'lm')
qplot(carat, price, data = dsmall, geom = c('point', 'smooth'), method = 'lm', formula = y ~ ns(x, 5))
library(MASS)
qplot(carat, price, data = dsmall, geom = c('point', 'smooth'), method = 'rlm')
qplot(color, price/carat, data = diamonds, geom = 'jitter', alpha = I(1/5))
qplot(color, price/carat, data = diamonds, geom = 'jitter', colour = 'red')
qplot(color, price/carat, data = diamonds, geom = 'jitter', alpha = I(1/50))
qplot(color, price/carat, data = diamonds, geom = 'jitter', alpha = I(1/200))

qplot(color, price/carat, data = diamonds, geom = 'boxplot', alpha = I(1/5))

qplot(carat, data = diamonds, geom = 'histogram')
qplot(carat, data = diamonds, geom = 'density')
qplot(carat, data = diamonds, geom = 'histogram', binwidth = 0.4, xlim = c(0, 3))
qplot(carat, data = diamonds, geom = 'histogram', binwidth = 0.5, xlim = c(0, 3))
qplot(carat, data = diamonds, geom = 'histogram', binwidth = 0.6, xlim = c(0, 3))

qplot(carat, data = diamonds, geom = 'density', colour = color)
qplot(carat, data = diamonds, geom = 'histogram', fill = color)
qplot(carat, data = diamonds, geom = 'histogram', fill = color, xlim = c(0, 3), binwidth = 0.5)
qplot(color, data = diamonds, geom = 'bar')
qplot(color, data = diamonds, geom = 'bar', weight = carat) + 
  scale_y_continuous('carat')
qplot(date, unemploy/pop, data = economics, geom = 'line')
qplot(date, uempmed, data = economics, geom = 'line')
year <- function(x) as.POSIXlt(x)$year + 1900
qplot(unemploy/pop, uempmed, data = economics, geom = c('point', 'path'))
qplot(unemploy/pop, uempmed, data = economics, geom = 'path', colour = year(date))
qplot(carat, data = diamonds, facets = color ~ ., 
      geom = 'histogram', binwidth = 0.1, xlim = c(0, 3))
qplot(carat, ..density.., data = diamonds, facets = color~., 
      geom = 'histogram', binwidth = 0.1, xlim = c(0, 3))
qplot(
  carat, price, data = dsmall, 
  xlab = 'Price ($)', ylab = 'Weight (carats)', 
  main = 'Price-weight relationship'
)

qplot(
  carat, price/carat, data = dsmall, 
  ylab = expression(frac(price, carat)), 
  xlab = 'Weight (carats)', 
  main = 'Small diamonds', 
  xlim = c(.2, 1)
)

qplot(carat, price, data = dsmall, log = 'xy')


library("ggplot2")
library("grid")
library("showtext")
library("Cairo")
font_add("myfont","msyh.ttc")

mydata<-data.frame(
  id=1:13,
  class=rep_len(1:4, length=13),
  Label=c("Events","Lead List","Partner","Markeiting & Advertising","Tradeshows","Paid Search","Webinar","Emial Campaign","Sales generated","Website","Other","Facebook/Twitter/\nOther Social","Employee & Customer\nReferrals"),
  Value=c(7.6,15.5,17.9,21.8,29.6,29.7,32.7,43.0,57.5,61.4,67.4,68.6,68.7)
)

p<-ggplot()+
  geom_col(data=mydata,aes(x=id,y=Value/2+150,fill=factor(class)),colour=NA,width=1)+
  geom_col(data=mydata,aes(x=id,y=150-Value/2),fill="white",colour="white",width=1)+
  geom_line(data=NULL,aes(x=rep(c(.5,13.5),2),y=rep(c(126,174),each=2),group=factor(rep(1:2,each=2))),linetype=2,size=.25)+
  geom_text(data=mydata,aes(x=id,y=ifelse(id<11,160,125),label=Label),size=3.5,hjust=0.5)+
  geom_text(data=mydata,aes(x=id,y=ifelse(id<11,185,150),label=paste0(Value,"%")),hjust=.5,size=4.5)+
  scale_x_continuous(limits=c(0,26),expand=c(0,0))+
  coord_polar(theta = "x",start=-14.275, direction = 1)+
  scale_fill_manual(values=c("#31A2CE","#DDB925","#3F9765","#C84F44"),guide=FALSE)+
  theme_void()
p

#图表标题、副标题title="Events,Lead Lists and partners-\nmore likely be colosed-lost"content="Marketing events may by fun, but they create\nlousy sales opprunities.When analyzing share\nof closed-won vs.closed-lost opportunities,\nevents,leads lists and partners seem to provide the\nworst performance,while refreals and social\nprovide the best performance."
#图形输出：setwd("E:/数据可视化/R/R语言学习笔记/数据可视化/ggplot2/优秀R语言案例")
title="Events,Lead Lists and partners-\nmore likely be colosed-lost"
content="Marketing events may by fun, but they create\nlousy sales opprunities.When analyzing share\nof closed-won vs.closed-lost opportunities,\nevents,leads lists and partners seem to provide the\nworst performance,while refreals and social\nprovide the best performance."
CairoPNG(file="polar_bar.png",width=1200,height=900)
showtext.begin()
grid.newpage()
pushViewport(viewport(layout=grid.layout(6,8)))
vplayout<-function(x,y){viewport(layout.pos.row =x,layout.pos.col=y)}
print(p,vp=vplayout(1:6,1:8))
grid.text(label=title,x=.50,y=.6525,gp=gpar(col="black",fontsize=15,fontfamily="myfont",draw=TRUE,fontface="bold",just="left"))
grid.text(label=content,x=.50,y=.56,gp=gpar(col="black",fontsize=12,fontfamily="myfont",draw=TRUE,just="left"))
showtext.end()
dev.off()

mpg
qplot(displ, hwy, data = mpg, colour = factor(cyl))
qplot(displ, hwy, data = mpg, facets = .~year) + 
  geom_smooth()
p <- qplot(displ, hwy, data = mpg, colour = factor(cyl))
summary(p)
print(p)
save(p, file = 'plot.rdata')
load('plot.rdata')
ggsave('plot.png', width = 5, height = 5)

p <- ggplot(diamonds, aes(carat, price, colour = cut))
# p <- p + layer(geom = 'point')
p <- p + geom_point()
print(p)

p <- ggplot(diamonds, aes(x = carat))
p <- p + layer(
  geom = 'bar', 
  geom_params = list(fill = 'steelblue'), 
  stat = 'bin', 
  stat_params = list(binwidth = 2)
)
p

p <- ggplot(diamonds, aes(x = carat))
p <- p + geom_histogram(binwidth = 2, fill = 'steelblue')
p

# ggplot和qplot等价的写法
ggplot(msleep, aes(sleep_rem / sleep_total, awake)) + geom_point()
qplot(sleep_rem / sleep_total, awake, data = msleep, geom = 'point')

# qplot添加图层
qplot(sleep_rem / sleep_total, awake, data = msleep) + geom_smooth()
qplot(sleep_rem / sleep_total, awake, data = msleep, geom = c('point', 'smooth'))
ggplot(msleep, aes(sleep_rem / sleep_total, awake)) + 
  geom_point() + 
  geom_smooth()

p <- ggplot(msleep, aes(sleep_rem / sleep_total, awake))
summary(p)
p <- p + geom_point()
summary(p)

library(scales)
bestfit <- geom_smooth(method = 'lm', se = F, colour = alpha('steelblue', 0.5), size = 2)
qplot(sleep_rem, sleep_total, data = msleep) + bestfit
qplot(awake, brainwt, data = msleep, log = 'y') + bestfit
qplot(bodywt, brainwt, data = msleep, log = 'xy') + bestfit

p <- ggplot(mtcars, aes(mpg, wt, colour = cyl)) + geom_point()
p
mtcars <- transform(mtcars, mpg = mpg^2)
p %+% mtcars

p <- ggplot(mtcars)
summary(p)
p <- p + aes(wt, hp)
summary(p)

p <- ggplot(mtcars, aes(x = mpg, y = wt))
p + geom_point()
p + geom_point(aes(colour = factor(cyl)))
p + geom_point(aes(y = disp))

p <- ggplot(mtcars, aes(mpg, wt))
p + geom_point(colour = 'darkblue')
p + geom_point(aes(colour = 'darkblue'))

p <- ggplot(Oxboys, aes(age, height, group = Subject)) + 
  geom_line()
p
p + geom_smooth(aes(group = Subject), method = 'lm', se = F)
p + geom_smooth(aes(group = 1), method = 'lm', size = 2, se = F)

boysbox <- ggplot(Oxboys, aes(Occasion, height)) + 
  geom_boxplot()
boysbox
boysbox + geom_line(aes(group = Subject), colour = '#3366FF')
xgrid <- with(df, seq(min(x), max(x), length = 50))

# 直方图用count和density两种形式
ggplot(diamonds, aes(carat)) + 
  geom_histogram(aes(y = ..density..), binwidth = 0.1)
ggplot(diamonds, aes(carat)) + 
  geom_histogram(binwidth = 0.1)
qplot(carat, ..density.., data = diamonds, geom = 'histogram', width = 1)

d <- ggplot(diamonds, aes(carat)) + xlim(0, 3)
d + stat_bin(aes(ymax = ..count..), binwidth = 0.1, geom = 'area')
d + stat_bin(
  aes(size = ..density..), binwidth = 0.1, 
  geom = 'point', position = 'identity'
)
# 热图代码执行不了
d + stat_bin(
  aes(y = 1, fill = ..count..), binwidth = 0.1, 
  geom = 'tile', position = 'identity'
)

require(nlme, quiet = TRUE, warn.conflicts = FALSE)
model <- lme(height ~ age, data = Oxboys, random = ~ 1 + age | Subject)
oplot <- ggplot(Oxboys, aes(age, height, group = Subject)) + geom_line()
oplot
age_grid <- seq(-1, 1, length = 10)
subjects <- unique(Oxboys$Subject)

preds <- expand.grid(age = age_grid, Subject = subjects)
preds$height <- predict(model, preds)
oplot + geom_line(data = preds, colour = '#3366FF', size = 0.4)

Oxboys$fitted <- predict(model)
Oxboys$resid <- with(Oxboys, fitted - height)
oplot %+% Oxboys + aes(y = resid) + geom_smooth(aes(group = 1))

model2 <- update(model, height ~ age + I(age ^ 2))
Oxboys$fitted2 <- predict(model2)
Oxboys$resid2 <- with(Oxboys, fitted2 - height)
oplot %+% Oxboys + aes(y = resid2) + geom_smooth(aes(group = 1))

df <- data.frame(
  x = c(3, 1, 5), 
  y = c(2, 4, 6), 
  label = c('a', 'b', 'c')
)
df
p <- ggplot(df, aes(x, y)) + xlab(NULL) + ylab(NULL)
p + geom_point() + labs(title = 'geom_point')
p + geom_bar(stat = 'identity') + labs(title = 'geom_bar(stat=\'identity\')')
p + geom_line() + labs(title = 'geom_line')
p + geom_area() + labs(title = 'geom_area')
p + geom_path() + labs(title = 'geom_path')
p + geom_text(aes(label = label)) + labs(title = 'geom_text')
p + geom_tile() + labs(title = 'geom_tile')
p + geom_polygon() + labs(title = 'geom_polygon')

df <- data.frame(
  x = c(3, 1, 3, 5, 1), 
  y = c(2, 4, 4, 6, 2), 
  label = c('a', 'b', 'c', 'd', 'e')
)
p <- ggplot(df, aes(x, y)) + xlab(NULL) + ylab(NULL)
p + geom_polygon() + labs(title = 'geom_polygon')

depth_dist <- ggplot(diamonds, aes(depth)) + xlim(58, 68)
depth_dist + 
  geom_histogram(aes(y = ..density..), binwidth = 0.1) + 
  facet_grid(cut ~ .)
depth_dist + 
  geom_histogram(aes(fill = cut), binwidth = 0.1, position = 'fill')
depth_dist + 
  geom_freqpoly(aes(y = ..density.., colour = cut), binwidth = 0.1)

library(plyr)
qplot(cut, depth, data = diamonds, geom = 'boxplot')
qplot(carat, depth, data = diamonds, geom = 'boxplot', group = round_any(carat, 0.1, floor), xlim = c(0, 3))

qplot(class, cty, data = mpg, geom = 'jitter')
qplot(class, drv, data = mpg, geom = 'jitter')

qplot(depth, data = diamonds, geom = 'density', xlim = c(54, 70))
ggplot(diamonds, aes(depth)) + geom_density() + xlim(54, 70)
qplot(depth, data = diamonds, geom = 'density', xlim = c(54, 70), fill = cut, alpha = I(0.2))
ggplot(diamonds, aes(depth)) + 
  geom_density(aes(fill = cut), alpha = I(0.2)) + 
  xlim(54, 70)

# 遮盖绘制问题
df <- data.frame(x = rnorm(2000), y = rnorm(2000))
norm <- ggplot(df, aes(x, y))
norm + geom_point()
norm + geom_point(shape = 1)
norm + geom_point(shape = '.')

norm + geom_point(colour = 'black', alpha = 1/3)
norm + geom_point(colour = 'black', alpha = 1/5)
norm + geom_point(colour = 'black', alpha = 1/10)

# 增加随机扰动
td <- ggplot(diamonds, aes(table, depth)) + 
  xlim(50, 70) + ylim(50, 70)
td + geom_point()
td + geom_jitter()
jit <- position_jitter(width = 0.5)
td + geom_jitter(position = jit)
td + geom_jitter(position = jit, colour = 'black', alpha = 1/10)
td + geom_jitter(position = jit, colour = 'black', alpha = 1/50)
td + geom_jitter(position = jit, colour = 'black', alpha = 1/200)

d <- ggplot(diamonds, aes(carat, price)) + xlim(1, 3) + theme(legend.position = 'none')
d + stat_bin2d()
d + stat_bin2d(bin = 10)
d + stat_bin2d(binwidth = c(0.02, 200))
library(hexbin)
d + stat_binhex()
d + stat_binhex(bins = 10) 
d + stat_binhex(binwidth = c(0.02, 200))

d <- ggplot(diamonds, aes(carat, price)) + xlim(1, 3) + theme(legend.position = 'none')
d + geom_point() + geom_density2d() # 基于等高线的密度展示
d + stat_density2d(geom = 'point', aes(size = ..density..), contour = F) +scale_size_area() # 基于点的密度展示
d + stat_density2d(geom = 'tile', aes(fill = ..density..), contour = F) # 基于色深的密度展示
last_plot() + scale_fill_gradient(limits = c(1e-5, 8e-4))

library(maps)
data(us.cities)
big_cities <- subset(us.cities, pop > 500000)
qplot(long, lat, data = big_cities) + borders('state', size = 0.5)
# ggplot(big_cities, aes(long, lat)) + borders('state', size = 0.5) # ggplot2画的图少了点，暂时不知道为什么
tx_cities <- subset(us.cities, country.etc == 'TX')
ggplot(tx_cities, aes(long, lat)) + 
  borders('county', 'texas', colour = 'grey70') + 
  geom_point(colour = 'black', alpha = 0.5)

states <- map_data('state')
arrests <- USArrests
names(arrests) <- tolower(names(arrests))
arrests$region <- tolower(rownames(USArrests))
choro <- merge(states, arrests, by = 'region')
choro <- choro[order(choro$order),]
qplot(long, lat, data = choro, group = group, fill = assault, geom = 'polygon')
qplot(long, lat, data = choro, group = group, fill = assault/murder, geom = 'polygon')

library(plyr)
ia <- map_data('county', 'iowa')
mid_range <- function(x) mean(range(x, na.rm = TRUE))
centres <- ddply(ia, .(subregion), colwise(mid_range, .(lat, long)))
ggplot(ia, aes(long, lat)) + 
  geom_polygon(aes(group = group), fill = NA, colour = 'grey60') + 
  geom_text(aes(label = subregion), data = centres, size = 2, angle = 45)

library(ggplot2)
d <- subset(diamonds, carat < 2.5 & rbinom(nrow(diamonds), 1, 0.2) == 1) # 二项分布随机选取部分数据
d$lcarat <- log10(d$carat)
d$lprice <- log10(d$price)

#剔除整体的线性趋势
detrend <- lm(lprice ~ lcarat, data = d)
d$lprice2 <- resid(detrend)

mod <- lm(lprice2 ~ lcarat * color, data = d)
library(effects)
effectdf <- function(...) {
  suppressWarnings(as.data.frame(effect(...)))
}
color <- effectdf('color', mod)
both1 <- effectdf('lcarat:color', mod)

carat <- effectdf('lcarat', mod, default.levels = 50)
both2 <- effectdf('lcarat:color', mod, default.levels = 3)

## 图5.14
qplot(lcarat, lprice, data = d, colour = color)
qplot(lcarat, lprice2, data = d, colour = color)
## 图5.15
fplot <- ggplot(mapping = aes(y = fit, ymin = lower, ymax = upper)) + 
  ylim(range(both2$lower, both2$upper))
fplot %+% color + aes(x = color) + geom_point() + geom_errorbar()
fplot %+% both2 + 
  aes(x = color, colour = lcarat, group = interaction(color, lcarat)) + 
  geom_errorbar() + 
  geom_line(aes(group = lcarat)) + 
  scale_colour_gradient()
##图5.16
fplot %+% carat + aes(x = lcarat) + 
  geom_smooth(stat = 'identity')

ends <- subset(both1, lcarat == max(lcarat))
fplot %+% both1 + aes(x = lcarat, colour = color) + 
  geom_smooth(stat = 'identity') + 
  scale_colour_hue() + 
  theme(legend.position = 'none') + 
  geom_text(aes(label = color, x = lcarat + 0.02), ends)

midm <- function(x) mean(x, trim = 0.5)
m2 + # m2未定义，无法执行 
  stat_summary(aes(colour = 'trimmed'), fun.y = midm, geom = 'point') + 
  stat_summary(aes(colour = 'raw'), fun.y = mean, geom = 'point') + 
  scale_colour_hue('Mean')

iqr <- function(x, ...) {
  qs <- quantile(as.numeric(x), c(0.25, 0.75), na.rm = T)
  names(qs) <- c('ymin', 'ymax')
  qs
}
#m未定义
m + stat_summary(fun.data = 'iqr', geom = 'ribbon')
unemp <- qplot(date, unemploy, data = economics, geom = 'line', xlab = '', ylab = 'No. unemployed (1000s)')
presidential <- presidential[-(1:3), ]
yrng <- range(economics$unemploy)
xrng <- range(economics$date)
unemp + geom_vline(aes(xintercept = as.numeric(start)), data = presidential)
library(scales)
unemp + 
  geom_rect(aes(NULL, NULL, xmin = start, xmax = end, fill = party), ymin = yrng[1], ymax = yrng[2], 
            data = presidential, alpha = 0.2) + 
  scale_fill_manual(values = c('blue', 'red'))
last_plot() + 
  geom_text(aes(x = start, y = yrng[1], label = name), data = presidential, size = 3, hjust = 0, vjust = 0)
caption <- paste(strwrap('Unemployment rates in the US have varied a lot over the years', 40), collapse = '\n')
unemp + 
  geom_text(aes(x, y, label = caption), data = data.frame(x = xrng[2], y = yrng[2]), hjust = 1, vjust = 1, size = 4)
highest <- subset(economics, unemploy == max(unemploy))
unemp + 
  geom_point(data = highest, size = 3, colour = 'red', alpha = 0.5)

qplot(percwhite, percbelowpoverty, data = midwest)
qplot(percwhite, percbelowpoverty, data = midwest, size = poptotal/1e6) + 
  scale_size_area('Population\n(millions)', breaks = c(0.5, 1, 2, 4))
qplot(percwhite, percbelowpoverty, data = midwest, size = area) + 
  scale_size_area()

lm_smooth <- geom_smooth(method = lm, size = 1)
qplot(percwhite, percbelowpoverty, data = midwest) + lm_smooth
qplot(percwhite, percbelowpoverty, data = midwest, weight = popdensity, size = popdensity) + lm_smooth

qplot(percbelowpoverty, data = midwest, binwidth = 1)
qplot(percbelowpoverty, data = midwest, weight = poptotal, binwidth = 1) + ylab('population')
