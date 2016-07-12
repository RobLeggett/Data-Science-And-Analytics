#Chapter 16: Market Basket Analysis: Association Rules and Lift

## Market basket analysis - looks at purchase coincidence, target marketing (recommending)
#  Investigates whether two products are be puchased together, and whether the 
#  the purchase of one product increases the liklihood of purchasing the other

## Matrix: Rows - shoppers, Columns - products, Binary = (0=not, 1=buy)
# P(A) = Probability of product A being purchased or consumed
# Support of A = supp(A) = The proportion of times event A occurred

# P(B) = Probability of product B being purchased or consumed
# Support of B = supp(B) = The proportion of times event B occurred

# P(A and B) = co-incidence = A & B consumed together
# Support of A and B = supp(A and B) = The proportion of times event A & B occurred together

# P(B|A) = conditional probability of B given A has occurred
# P(B|A) = P(A and B) / P(A) = coincidence of B
# Confidence of P(B|A) = supp(A and B) / supp(A)
# Supports come from incidence matrix

## Lift - if ratio > 1, then A results in upward lift on B; A increase chance of B
# Lift of A on B = lift(A to B) = P(B|A)/P(B) = P(A and B)/(P(A)*P(B))

## Leverage: If leverage = 0 means no association; If lev >= 0, then A has lift on B
# Leverage(A to B) = [lift(A to B)-1]*P(A)*P(B)

