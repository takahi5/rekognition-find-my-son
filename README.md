# rekognition-find-my-son

保育園の膨大な写真リストから、我が子が写っている写真を抽出するスクリプト。
Amazon Rekognitionを利用しています。

Find picures with a person from many pictures.
Using Amazon Rekognition API.

## Usage

1. Create `.env`
```
AWS_REGION=ap-northeast-1
AWS_ACCESS_KEY_ID=AKI**********
AWS_SECRET_ACCESS_KEY=****************
```
The access key must have the permission of Amazon Rekognition.

2. Save target images to images directory

3. Save source image to root directory

4. `ruby compare_faces.rb ./source.jpg`

5. Result images will be saved in results directory
