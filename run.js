var size = 100
var windowlist = []

for (var i=0; i< size; i++)
{
   windowlist.push(window.open("https://www.zyxr.com/invest/debt.html?pageNum="+(i+1+index)))
}


for (var i = 0; i< size; i++)
{
   var blob = new Blob([JSON.stringify(windowlist[index%size].dataList)], {
    type: 'text/plain'
 	});
    var aLink = document.createElement('a');
	aLink.download = 1+index
	aLink.href = URL.createObjectURL(blob);
	aLink.click();
  index++
}

for (var i=0; i< size; i++)
{
	windowlist[i].close()
}


var index = 1230
