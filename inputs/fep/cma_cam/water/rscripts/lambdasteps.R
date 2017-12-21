lambdas <- read.csv("lambdaspacing.dat", header = FALSE)

lambdas[2,]-lambdas[1,]
lambdas[3,]-lambdas[2,]
lambdas[4,]-lambdas[3,]


xs <- 0.5+(-1/2*cos((seq(1,31)/31)*pi))
#xs <- exp((-1/2)*(seq(-31,30,2)/31)^2)
#xs <- (1.0*(seq(1,31)/31)+(0.1^2))

lambdadiff <- apply(lambdas, 2, diff)
lambdadiffdiff <- apply(lambdadiff, 2, diff)

fit.md  <- lm(seq(1,31) ~ lambdas[,1])

par(mfrow=c(2,2))

plot(lambdas[,2],seq(1,31))
lines(lambdas[,2],seq(1,31), xlab="lambdapoint")
lines(xs,seq(1,31), xlab="lambdapoint", col="red")
#plot(fit.md, col="blue")

plot(xs,seq(1,31))
lines(xs,seq(1,31), xlab="lambdapoint")

plot(seq(1,30), lambdadiff[,1])
lines(seq(1,30), lambdadiff[,1], xlab="lambdapoint")

plot(seq(1,29), lambdadiffdiff[,1])
lines(seq(1,29), lambdadiffdiff[,1], xlab="lambdapoint")
