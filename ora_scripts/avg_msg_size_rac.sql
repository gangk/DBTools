select sum(kjxmsize*(kjxmrcv+kjxmsnt+kjxmqsnt))/sum((kjxmrcv+kjxmsnt+kjxmqsnt))
from x$kjxm
where kjxmrcv > 0 or kjxmsnt > 0 or kjxmqsnt >0;