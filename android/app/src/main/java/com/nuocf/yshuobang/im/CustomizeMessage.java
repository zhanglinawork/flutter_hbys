package com.nuocf.yshuobang.im;

import android.os.Parcel;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import io.rong.common.ParcelUtils;
import io.rong.imlib.MessageTag;
import io.rong.imlib.model.MentionedInfo;
import io.rong.imlib.model.MessageContent;
import io.rong.imlib.model.UserInfo;

/**
 * Created by user on 2017/8/25.
 */
@MessageTag(value = "CustomizeMessage", flag = MessageTag.ISCOUNTED | MessageTag.ISPERSISTED)
public class CustomizeMessage extends MessageContent {

    private String name;
    private String age;
    private String gender;
    private String desc;
    private String order_id;
    private String img;
    private String serviceId;

    public ArrayList<String> getFirst_images() {
        return first_images;
    }

    public void setFirst_images(ArrayList<String> first_images) {
        this.first_images = first_images;
    }

    private ArrayList<String> first_images;


    public String getImg() {
        return img;
    }
    public void setImg(String img) {
        this.img = img;
    }
    public String getServiceId() {
        return serviceId;
    }

    public void setServiceId(String serviceId) {
        this.serviceId = serviceId;
    }

    public String getOrder_id() {
        return order_id;
    }

    public void setOrder_id(String order_id) {
        this.order_id = order_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    @Override
    public byte[] encode() {
        JSONObject jsonObj = new JSONObject();
        try {
            jsonObj.put("name", this.getName());
            jsonObj.put("age", this.getAge());
            jsonObj.put("gender", this.getGender());
            jsonObj.put("desc", this.getDesc());
            jsonObj.put("order_id", this.getOrder_id());
            jsonObj.put("img",this.getImg());
            jsonObj.put("first_images",this.getFirst_images());

            if(this.getJSONUserInfo() != null) {
                jsonObj.putOpt("user", this.getJSONUserInfo());
            }
            if(this.getJsonMentionInfo() != null) {
                jsonObj.putOpt("mentionedInfo", this.getJsonMentionInfo());
            }
        } catch (JSONException e) {
            Log.e("JSONException", e.getMessage());
        }
        try {
            return jsonObj.toString().getBytes("UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return null;
    }

    public CustomizeMessage(byte[] data) {
        String jsonStr = null;

        try {
            jsonStr = new String(data, "UTF-8");
        } catch (UnsupportedEncodingException e1) {
            e1.printStackTrace();
        }

        try {
            JSONObject jsonObj = new JSONObject(jsonStr);

            if (jsonObj.has("name")) {
                setName(jsonObj.optString("name"));
            }

            if (jsonObj.has("age")) {
                setAge(jsonObj.optString("age"));
            }

            if (jsonObj.has("gender")) {
                setGender(jsonObj.optString("gender"));
            }

            if (jsonObj.has("desc")) {
                setDesc(jsonObj.optString("desc"));
            }
            if (jsonObj.has("img")){
                setImg(jsonObj.optString("img"));
            }
            if (jsonObj.has("first_images")){
                ArrayList<String> listdata = new ArrayList<String>();
                JSONArray jArray = jsonObj.getJSONArray("first_images");
                if (jArray != null) {
                    for (int i=0;i<jArray.length();i++){
                        listdata.add(jArray.getString(i));
                    }
                }
                setFirst_images(listdata);
            }


            if (jsonObj.has("order_id")) {
                setOrder_id(jsonObj.optString("order_id"));
            }
            if(jsonObj.has("user")) {
                this.setUserInfo(this.parseJsonToUserInfo(jsonObj.getJSONObject("user")));
            }
            if(jsonObj.has("mentionedInfo")) {
                this.setMentionedInfo(this.parseJsonToMentionInfo(jsonObj.getJSONObject("mentionedInfo")));
            }


        } catch (JSONException e) {
            Log.d("JSONException", e.getMessage());
        }
    }

    @Override
    public int describeContents() {
        return 0;
    }
    //给消息赋值。
    public CustomizeMessage(Parcel in) {
        //这里可继续增加你消息的属性
        setName(ParcelUtils.readFromParcel(in));//该类为工具类，消息属性
        setAge(ParcelUtils.readFromParcel(in));//该类为工具类，消息属性
        setGender(ParcelUtils.readFromParcel(in));//该类为工具类，消息属性
        setDesc(ParcelUtils.readFromParcel(in));//该类为工具类，消息属性
        setOrder_id(ParcelUtils.readFromParcel(in));//该类为工具类，消息属性
        setImg(ParcelUtils.readFromParcel(in));
        setFirst_images((ArrayList<String>) in.readSerializable());

        this.setUserInfo((UserInfo) ParcelUtils.readFromParcel(in, UserInfo.class));
        this.setMentionedInfo((MentionedInfo) ParcelUtils.readFromParcel(in, MentionedInfo.class));

    }
    @Override
    public void writeToParcel(Parcel dest, int flags) {
        ParcelUtils.writeToParcel(dest, getName());
        ParcelUtils.writeToParcel(dest, getAge());
        ParcelUtils.writeToParcel(dest, getGender());
        ParcelUtils.writeToParcel(dest, getDesc());
        ParcelUtils.writeToParcel(dest, getOrder_id());
        ParcelUtils.writeToParcel(dest,getImg());
        dest.writeSerializable(getFirst_images());
        //ParcelUtils.writeToParcel(dest,getFirst_images());
        ParcelUtils.writeToParcel(dest, this.getUserInfo());
        ParcelUtils.writeToParcel(dest, this.getMentionedInfo());

    }
    /**
     * 读取接口，目的是要从Parcel中构造一个实现了Parcelable的类的实例处理。
     */
    public static final Creator<CustomizeMessage> CREATOR = new Creator<CustomizeMessage>() {

        @Override
        public CustomizeMessage createFromParcel(Parcel source) {
            return new CustomizeMessage(source);
        }

        @Override
        public CustomizeMessage[] newArray(int size) {
            return new CustomizeMessage[size];
        }
    };

}
