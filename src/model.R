# fit logistic regression model
# -----------------------------------------
f = formula(survived ~ age + sex + pclass + child + sibsp + mother + father)
lr_model = glm(data = train, 
               family = binomial, 
               formula = f)

# test predictions
# -----------------------------------------
test_pred = as.numeric(predict(lr_model, train, type='response') > 0.5)


# ...accuracy 
print(sprintf('Test accuracy: %f perc', mean(test_pred == train$survived)))

# ...confusion matrix
tbl = table(truth = train$survived, pred = test_pred)
print(tbl)
print(prop.table(tbl, 2))

#  ...model summary
print(summary(lr_model))
