library(ustreasuries)
context("Test the options-pricing utilities")

# Test N & N'
# ===========
test_that("N standard normal CDF 'en' should equal pnorm", {
    for (x in seq(from=-5, to=5, by=0.1))
        expect_equal(all.equal(en(x), pnorm(x), tolerance=0.01), TRUE)
})

test_that("N' standard normal PDF 'nprime' should equal dnorm", {
    for (x in seq(from=-5, to=5, by=0.1))
        expect_equal(all.equal(nprime(x), dnorm(x), tolerance=0.01), TRUE)
})

# Test put/call parity
# ====================
Stock    <- 49
Exercise <- 50
Time     <- 20/52
Interest <- 0.05
Yield    <- 0.13#0
sigma    <- 0.20
EC = EuroCall(Stock, Exercise, Time, Interest, Yield, sigma)
EP = EuroPut(Stock, Exercise, Time, Interest, Yield, sigma)
PC = CallParity(Stock, Exercise, Time, Interest, Yield, EP)
PP = PutParity(Stock, Exercise, Time, Interest, Yield, EC)
test_that("Test Put/Call Parity", {
    expect_equal(all.equal(EC, PC, tolerance=0.000001), TRUE)
    expect_equal(all.equal(EP, PP, tolerance=0.000001), TRUE)
})

# Test forward price
# ==================
# Hull 7th edition Ch 5 P 103
Spot     <- 40
Time     <- 0.25
Interest <- 0.05
Yield    <- 0
Income   <- 0
FP = ForwardPrice(Spot, Time, Interest, Yield, Income)
test_that("Find forward price", {
    expect_equal(all.equal(FP, 40.50, tolerance=0.001), TRUE)
})

# Test discrete-to-continuous compounding
# =======================================
r_discrete                   <- 0.04
compounding_periods_per_year <- 2
ans <- r_continuous(r_discrete, compounding_periods_per_year)
test_that("Test discrete-to-continuous compounding", {
    expect_equal(all.equal(ans, 0.03960525, tolerance=0.000001), TRUE)
})

# Test IntrinsicValueCall/Put
# ===========================
Stock    <- 25 # S_0
Exercise <- 15 # K
ivc <- IntrinsicValueCall(Stock, Exercise) # 10
ivp <- IntrinsicValuePut(Exercise, Stock) # 10
test_that("Test intrinsic value call/put", {
    expect_equal(all.equal(ivc, 10, tolerance=0.000001), TRUE)
    expect_equal(all.equal(ivp, 10, tolerance=0.000001), TRUE)
})

# Test InTheMoneyCall/Put
# ===========================
Stock    <- 37.75     # S_0
Exercise <- 35        # K
itmc <- InTheMoneyCall(Stock, Exercise) # TRUE
itmp <- InTheMoneyPut(Exercise, Stock) # TRUE
test_that("Test intrinsic value call/put", {
    expect_equal(itmc, TRUE)
    expect_equal(itmp, TRUE)
})

# Test TimeValueCall/TimeValuePut
# ===============================
Stock      <- 21     # S_0
Exercise   <- 20     # K
Call_price <- 1.875
Put_price  <- 1.875

calltv <- TimeValueCall(Stock, Exercise, Call_price)
puttv  <- TimeValuePut(Stock, Exercise, Put_price)

test_that("TimeValueCall/TimeValuePut", {
    expect_equal(all.equal(calltv, 0.875, tolerance=0.0001), TRUE)
    expect_equal(all.equal(puttv,  1.875, tolerance=0.0001), TRUE)
})


