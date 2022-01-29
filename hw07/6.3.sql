-- Big Brother Kirpich is watching you..
create trigger PreserverMarks on Marks
after update 
referencing new row as newRow old row as oldRow
for each row set
  newRow.Mark = 
  case
    when newRow.Mark < oldRow.Mark then oldRow.Mark
    when newRow.Mark > oldRow.mark then newRow.Mark
  end
end
