# AL-Translation-Tool
FLAME ESD Translation Tool

I already have long time experience in develop NAV, include the pain about translations. Changing to AL is an interesting journey. But the translation keeps a pain. I searched for some tool makes life easier. There are some good extensions in VS Code. But if you must add much translations and if you are changing the structure of your code, you need to do a lot of manual steps. Usually a developer not like this so much. 
To use it you need to make a small setup. I think the purpose of the fields are clear.
 ![image](https://user-images.githubusercontent.com/54331456/188576747-048ca108-11eb-4064-8e92-55e0649962c2.png)

The translations will be done based on dictionary. This dictionary will be filled automatically if you translate a project or you can care them by your own manually. Another way is to import the translation file of C/Side.
 ![image](https://user-images.githubusercontent.com/54331456/188576818-eb500bd3-a872-4066-a233-6557eccac7d5.png)
![image](https://user-images.githubusercontent.com/54331456/188576852-ffd9bd95-ae6f-42e1-81cc-0aeb51868fad.png)

 
To use this feature, you can ease use the existing translation from c/side. This feature makes it for different parts much easier. And you save a lot of time in Copy and Paste tasks.
After the setups you can start to create your translation project, by import the xlf-File. For a specific language you need to copy the *.g.xlf file first and change the target language code. Our tool only adds or change the Texts in the target tags. To import you need to add first the File Location in the list and then press the action import.
![image](https://user-images.githubusercontent.com/54331456/188576897-d7c9a22b-2dcd-46b2-b74b-01bb11e91301.png)
  
![image](https://user-images.githubusercontent.com/54331456/188576979-62975f60-bdae-4f23-945b-45bb381763a8.png)
  
Technically the tool will import the file and put all information in a table. You can see this information by click on the Translate File Action.
To start your translation, you need to show the Translation Notes.
![image](https://user-images.githubusercontent.com/54331456/188576945-3ef24910-23f1-4d51-92ea-5245e27c01d2.png)
 
 
This list is generating during the import. Every Source Text you will find only one time, we aggregate them. From this list you can jump to the dictionary and can make the translations. The easiest way is to translate all. Based on the dictionary the source texts will be translated. But there is no spelling check, the tool search if a Source Text match exactly to an expression in the dictionary list.
 
 ![image](https://user-images.githubusercontent.com/54331456/188577024-df3e0346-96d8-4832-9819-93d15e00c8cf.png)

If some text cannot be found, the tool tries to translate the text by using google translate. We add a parameter that this is translated by web. That makes it easy review these parts. If you change or add some Target Text in this list, the dictionary and the translation file will be update for the source text.
After work on your translations you can export the file again and copy into your al project.

For our first projects this works fine and save us much time. Especially if you make much changes, like change Object Names or -ID, extract some parts in a separate Extensions or add similar fields to more tables. Feel free to use that tool and play around. Any suggestions or comments are welcome.

 







