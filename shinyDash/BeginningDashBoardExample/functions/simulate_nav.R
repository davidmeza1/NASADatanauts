simulate_nav <- function(start_capital = 2000000, annual_mean_return = 5.0,
                         annual_ret_std_dev = 7.0, annual_inflation = 2.5,
                         annual_inf_std_dev = 1.5, monthly_withdrawals = 1000,
                         n_obs = 20, n_sim = 200) {
     #-------------------------------------
     # Inputs
     #-------------------------------------
     
     # Initial capital
     start.capital = start_capital
     
     # Investment
     annual.mean.return = annual_mean_return / 100
     annual.ret.std.dev = annual_ret_std_dev / 100
     
     # Inflation
     annual.inflation = annual_inflation / 100
     annual.inf.std.dev = annual_inf_std_dev / 100
     
     # Withdrawals
     monthly.withdrawals = monthly_withdrawals
     
     # Number of observations (in Years)
     n.obs = n_obs
     
     # Number of simulations
     n.sim = n_sim
     
     
     #-------------------------------------
     # Simulation
     #-------------------------------------
     
     # number of months to simulate
     n.obs = 12 * n.obs
     
     # monthly Investment and Inflation assumptions
     monthly.mean.return = annual.mean.return / 12
     monthly.ret.std.dev = annual.ret.std.dev / sqrt(12)
     
     monthly.inflation = annual.inflation / 12
     monthly.inf.std.dev = annual.inf.std.dev / sqrt(12)
     
     # simulate Returns
     monthly.invest.returns = matrix(0, n.obs, n.sim)
     monthly.inflation.returns = matrix(0, n.obs, n.sim)
     
     monthly.invest.returns[] = rnorm(n.obs * n.sim, mean = monthly.mean.return, sd = monthly.ret.std.dev)
     monthly.inflation.returns[] = rnorm(n.obs * n.sim, mean = monthly.inflation, sd = monthly.inf.std.dev)
     
     # simulate Withdrawals
     nav = matrix(start.capital, n.obs + 1, n.sim)
     for (j in 1:n.obs) {
          nav[j + 1, ] = nav[j, ] * (1 + monthly.invest.returns[j, ] - monthly.inflation.returns[j, ]) - monthly.withdrawals
     }
     
     # once nav is below 0 => run out of money
     nav[ nav < 0 ] = NA
     
     # convert to millions
     nav = nav / 1000000
     
     return(nav)
}