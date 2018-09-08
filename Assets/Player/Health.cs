using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Health : MonoBehaviour
{

    [Range(0, 100f)]
    public float HP = 100f;

    public Text text;

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        text.text = "Health: " + HP;
        if (HP == 0)
        {
            Debug.Log("Help I died!");
            Destroy(gameObject);
        }
    }
}
