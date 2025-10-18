less memory_contents_0.mif 
grep -E '^\s+[\[0-9]' memory_contents_0.mif 
for i in {0..49}; do echo ${i}; done
for i in {0..49}; do grep -E '^\s+[\[0-9]' memory_contents_${i}.mif > memory_data_${i}.txt; done
less memory_data_0.txt 
for i in {0..49}; do sed -i -re 's/^\s+//g' memory_data_${i}.txt; done
