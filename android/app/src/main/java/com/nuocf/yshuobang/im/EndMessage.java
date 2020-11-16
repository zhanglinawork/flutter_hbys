package com.nuocf.yshuobang.im;

import android.os.Parcel;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;

import io.rong.common.ParcelUtils;
import io.rong.imlib.MessageTag;
import io.rong.imlib.model.MentionedInfo;
import io.rong.imlib.model.MessageContent;
import io.rong.imlib.model.UserInfo;

/**
 * Created by user on 2017/8/25.
 */
@MessageTag(value = "EndMessage", flag = MessageTag.ISCOUNTED | MessageTag.ISPERSISTED)
public class EndMessage extends MessageContent {
    private String content;
    private String order_id;
    private String end_tag;

    public String getServiceId() {
        return serviceId;
    }

    public void setServiceId(String serviceId) {
        this.serviceId = serviceId;
    }

    private String serviceId;

    public String getEnd_tag() {
        return end_tag;
    }

    public void setEnd_tag(String end_tag) {
        this.end_tag = end_tag;
    }

    public String getOrder_id() {
        return order_id;
    }

    public void setOrder_id(String order_id) {
        this.order_id = order_id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    @Override
    public byte[] encode() {
        JSONObject jsonObj = new JSONObject();
        try {
            jsonObj.put("content", this.getContent());
            jsonObj.put("order_id", this.getOrder_id());
            jsonObj.put("end_tag", this.getEnd_tag());
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

    public EndMessage(byte[] data) {
        String jsonStr = null;

        try {
            jsonStr = new String(data, "UTF-8");
        } catch (UnsupportedEncodingException e1) {
            e1.printStackTrace();
        }

        try {
            JSONObject jsonObj = new JSONObject(jsonStr);

            if (jsonObj.has("content")) {
                setContent(jsonObj.optString("content"));
            }
            if (jsonObj.has("order_id")) {
                setOrder_id(jsonObj.optString("order_id"));
            }
            if (jsonObj.has("end_tag")) {
                setEnd_tag(jsonObj.optString("end_tag"));
            }
            if (jsonObj.has("user")) {
                this.setUserInfo(this.parseJsonToUserInfo(jsonObj.getJSONObject("user")));
            }
            if (jsonObj.has("mentionedInfo")) {
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
    public EndMessage(Parcel in) {
        //这里可继续增加你消息的属性
        setContent(ParcelUtils.readFromParcel(in));//该类为工具类，消息属性
        setOrder_id(ParcelUtils.readFromParcel(in));//该类为工具类，消息属性
        setEnd_tag(ParcelUtils.readFromParcel(in));//该类为工具类，消息属性


        //add
        this.setUserInfo((UserInfo) ParcelUtils.readFromParcel(in, UserInfo.class));
        this.setMentionedInfo((MentionedInfo) ParcelUtils.readFromParcel(in, MentionedInfo.class));

    }
    @Override
    public void writeToParcel(Parcel dest, int flags) {
        ParcelUtils.writeToParcel(dest, getContent());
        ParcelUtils.writeToParcel(dest, getOrder_id());
        ParcelUtils.writeToParcel(dest, getEnd_tag());

        //add
        ParcelUtils.writeToParcel(dest, this.getUserInfo());
        ParcelUtils.writeToParcel(dest, this.getMentionedInfo());
    }
    /**
     * 读取接口，目的是要从Parcel中构造一个实现了Parcelable的类的实例处理。
     */
    public static final Creator<EndMessage> CREATOR = new Creator<EndMessage>() {

        @Override
        public EndMessage createFromParcel(Parcel source) {
            return new EndMessage(source);
        }

        @Override
        public EndMessage[] newArray(int size) {
            return new EndMessage[size];
        }
    };

}
